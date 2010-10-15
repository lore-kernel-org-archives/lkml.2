Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0JOTzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:55:02 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:39593 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932498Ab0JOTy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:54:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Uh7QiOeW0rrf/ItqpwuVO3ATukmQpvKlgnvosdeazgqzCKQE4c8SovskNcOhvUyHmBlxlmSRNxwHiULtuJJ1y3Tpn/+IecWQ1D5oWJubKFKDf/D5ylgL9xZsPTYDprlW;
Date: Fri, 15 Oct 2010 12:54:40 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: matt mooney <mfm@muteddisk.com>
Cc: kernel-janitors@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/24] pci: change to new flag variable
Message-ID: <20101015125440.6e5f6dfc@jbarnes-desktop>
In-Reply-To: <f8ffc630c8a56ebd5da0aa2227d63fecc21d4ee7.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
	<70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
	<40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
	<b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
	<2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
	<ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
	<8cea68a58c5ddba79fc96e93fa0b23681e6a7ffe.1285355033.git.mfm@muteddisk.com>
	<e93a3f1af26d2b0fc798b4c15401b3422ae6e2bd.1285355033.git.mfm@muteddisk.com>
	<c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
	<efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
	<facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
	<f8ffc630c8a56ebd5da0aa2227d63fecc21d4ee7.1285355033.git.mfm@muteddisk.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 12:17:26 -0700
matt mooney <mfm@muteddisk.com> wrote:

> Replace EXTRA_CFLAGS with ccflags-y.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
>  drivers/pci/Makefile |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index dc1aa09..dcd7ace 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -65,6 +65,4 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
>  
>  obj-$(CONFIG_PCI_STUB) += pci-stub.o
>  
> -ifeq ($(CONFIG_PCI_DEBUG),y)
> -EXTRA_CFLAGS += -DDEBUG
> -endif
> +ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
