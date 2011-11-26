Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1KZTOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 14:14:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48592 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753694Ab1KZTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 14:14:34 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/dLoxs6DPdGlVKELtgRlWvdn1F0lIZZFSPVdwyWr
	I3bQMsImp5fpMq
Message-ID: <4ED13A7A.1090504@gmx.de>
Date: Sat, 26 Nov 2011 19:14:02 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes to the fbdev subsystem.
Nothing exciting here, just one regression fix for viafb, 3 trivial patches for
OMAP and one patch to fix the reset sequence for da8xx-fb.


Thanks,

Florian Tobias Schandinat


The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://github.com/schandinat/linux-2.6.git fbdev-for-linus

Daniel Drake (1):
      viafb: correct sync polarity for OLPC DCON

Florian Tobias Schandinat (1):
      Merge branch 'for-3.2-rc' of git://gitorious.org/linux-omap-dss2/linux
into fbdev-for-linus

Manjunathappa, Prakash (1):
      video:da8xx-fb: Disable and reset sequence on version2 of LCDC

Tomi Valkeinen (3):
      OMAPDSS: HDMI: fix returned HDMI pixel clock
      OMAPFB: fix compilation warnings due to missing include
      OMAPDSS: DISPC: skip scaling calculations when not scaling

 drivers/video/da8xx-fb.c        |   15 ++++++++++++++-
 drivers/video/omap/dispc.c      |    1 +
 drivers/video/omap2/dss/dispc.c |   11 +++++------
 drivers/video/omap2/dss/hdmi.c  |    2 +-
 drivers/video/via/share.h       |    4 ++--
 5 files changed, 23 insertions(+), 10 deletions(-)
