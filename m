Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0LTQPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:15:50 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36972 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056Ab0LTQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:15:48 -0500
Date: Tue, 21 Dec 2010 01:14:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.37-rc7
Message-ID: <20101220161418.GG26766@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git fbdev-fixes-for-linus

Which contains:

Tomi Valkeinen (2):
      OMAP: DSS: VRAM: Align start & size of vram to 2M
      OMAP: OMAPFB: disable old omapfb for OMAP4 builds

 drivers/video/omap/Kconfig |    4 ++--
 drivers/video/omap2/vram.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
