Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1AMPRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:17:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50869 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab1AMPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:17:47 -0500
Date: Thu, 13 Jan 2011 16:17:36 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
Message-ID: <20110113151736.GW24920@pengutronix.de>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
 <8952.1294927845@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8952.1294927845@jrobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 13, 2011 at 11:10:45PM +0900, J. R. Okajima wrote:
> Thomas Gleixner:
> > The dcache scalability work broke NFS root filesystems.
> 	:::
> > Check for parent equal dentry and skip the nested lock to avoid the
> > deadlock. I'm sure this is the wrong fix, but at least it "works" :)
> 
> With this patch, can you unmount it cleanly?
> It skips incrementing d_count for both dentries.
> Do we need at least one?
If you tell me how to test that, I volunteer to try.
Something involving pivot_root?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
