Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab1EBWOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:14:11 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:32783 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab1EBWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:14:09 -0400
Date: Mon, 2 May 2011 16:14:06 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Wolfram Sang <w.sang@pengutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v6 0/6] powerpc, 52xx: add charon board support
Message-ID: <20110502221406.GA15043@ponder.secretlab.ca>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300782452-528-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 09:27:26AM +0100, Heiko Schocher wrote:
> cc: Wolfram Sang <w.sang@pengutronix.de>
> cc: Grant Likely <grant.likely@secretlab.ca>
> cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> cc: linux-fbdev@vger.kernel.org
> cc: devicetree-discuss@ozlabs.org
> cc: Ben Dooks <ben@simtec.co.uk>
> cc: Vincent Sanders <vince@simtec.co.uk>
> cc: Samuel Ortiz <sameo@linux.intel.com>
> cc: linux-kernel@vger.kernel.org
> cc: Randy Dunlap <rdunlap@xenotime.net>
> cc: Wolfgang Denk <wd@denx.de>
> cc: Paul Mundt <lethal@linux-sh.org>
> 
> changes since v5:
> - repost complete patchseries, as Paul Mundt suggested
> - rebased against current head
> - add Acked-by from Samuel Ortiz (MFD parts)
>   http://www.spinics.net/lists/linux-fbdev/msg02550.html
>   http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-01/msg11798.html
> 
>   and Benjamin Herrenschmidt (DTS parts)
>   http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-February/088279.html
> - removed patch 
>   "powerpc, mpc5200: update mpc5200_defconfig to fit for charon board."
>   therefore added
>   "powerpc, tqm5200: update tqm5200_defconfig to fit for charon board."

Refresh my memory, why was the mpc5200_defconfig updated dropped?

g.

