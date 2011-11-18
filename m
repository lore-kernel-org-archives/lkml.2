Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab1KRQgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:36:10 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53240 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758094Ab1KRQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:35:50 -0500
X-Sasl-enc: yCI9jJ8qg0AwNP93hnBFF6CB9kFir0m/BGy+IQLHCSGW 1321634149
Date: Fri, 18 Nov 2011 08:19:09 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rong Wang <Rong.Wang@csr.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the tty tree with the s5p tree
Message-ID: <20111118161909.GB30462@kroah.com>
References: <20111118142259.f3e509297b2a0046bec6df88@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118142259.f3e509297b2a0046bec6df88@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 02:22:59PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/Kconfig between commit 30fba06ac9eb ("serial: samsung:
> merge probe() function from all SoC specific extensions") from the s5p tree
> and commit 161e773cbd0c ("UART: add CSR SiRFprimaII SoC on-chip uart
> drivers") from the tty tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks fine, thanks.

greg k-h
