Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab1IJJAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 05:00:54 -0400
Received: from www.covariable.com ([216.129.123.154]:58760 "EHLO sweaglesw.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab1IJJAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 05:00:53 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Sep 2011 05:00:53 EDT
Date: Sat, 10 Sep 2011 01:55:47 -0700
From: djwong@djwong.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH] logo: Change regular 224-color tux logo to something more
 appropriate for Linux 3.1
Message-ID: <20110910085546.GV23283@sweaglesw.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Linux 3.1, I thought we could change the 224-color framebuffer logo to
something more apropos given the version number.  As the patch is quite large,
I'm only inlining the changelog. 8)

See http://djwong.org/docs/31-tuxlogo.patch for too-large-for-lkml patch,
http://djwong.org/docs/31-tuxlogo.png  for a PNG logo, or
http://djwong.org/docs/31-tuxlogo-screen.png for a screenshot.

Singed-off-by: Darrick J. Wong <djwong@djwong.org>
---

 drivers/video/logo/logo_linux_clut224.ppm |39322 ++++++++++++++++++++++++++++-
 1 files changed, 37720 insertions(+), 1602 deletions(-)

