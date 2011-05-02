Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab1EBWb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:31:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53308 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab1EBWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:31:25 -0400
Date: Mon, 2 May 2011 16:31:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Heiko Schocher <hs@denx.de>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v6 6/6] powerpc, tqm5200: update tqm5200_defconfig to fit
 for charon board.
Message-ID: <20110502223120.GD15187@ponder.secretlab.ca>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
 <1300782452-528-7-git-send-email-hs@denx.de>
 <20110322091027.GC2134@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322091027.GC2134@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:10:27AM +0100, Wolfram Sang wrote:
> >     As this board is tqm5200 based, added necessary changes
> >     to the tqm5200_defconfig. In previous patchserie I added
> >     the changes to mpc5200_defconfig, as Wolfram Sang mentioned,
> >     but as tqm5200_defconfig is in mainline, and the board is
> >     tqm5200 based, I think, thats the appropriate place, as
> 
> I'd think the perfect solution would have been to merge the
> tqm-defconfig into the mpc5200-defconfig entirely and get rid of it.
> That being said, I don't think this issue is big enough to block this
> series, so fine enough with me.

Merged, thanks.

g.



