Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2ENS5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:57:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7191 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab2ENS5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:57:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 May 2012 11:57:11 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 May 2012 20:57:07 +0200
Subject: Re: [v2 1/1] memory: tegra{20,30}-mc: Use dev_err_ratelimited()
Thread-Topic: [v2 1/1] memory: tegra{20,30}-mc: Use dev_err_ratelimited()
Thread-Index: Ac0yA1yES7p35ucpRV6ak8kIhfSZ9A==
Message-ID: <20120514.215707.1844280772142880591.hdoyu@nvidia.com>
References: <1336981680-15297-2-git-send-email-hdoyu@nvidia.com><1336990031-15567-1-git-send-email-hdoyu@nvidia.com><4FB14FDE.2080409@wwwdotorg.org>
In-Reply-To: <4FB14FDE.2080409@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stepehn,

Stephen Warren <swarren@wwwdotorg.org> wrote @ Mon, 14 May 2012 20:33:02 +0200:

> On 05/14/2012 04:07 AM, Hiroshi DOYU wrote:
> > Introduce a new dev_*_ratelimited() instead of pr_*_ratelimited() for
> > better info to print.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> But note that this relies on the following patch or a variant of it:
> 
> http://patchwork.ozlabs.org/patch/158899/
> 
> which isn't anywhere yet.
> 
> (A variant of that patch was patch 1/2 the first time this patch was
> posted, but v2 of this patch was posted separately without mentioning
> the dependency)

Greg has put the dependee patch in:

http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commit;h=6ca045930338485a8cdef117e74372aa1678009d

Anyway, I should have described the above dependency in commit note in
the patch, sorry for confusion.
