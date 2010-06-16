Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0FPLzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:55:52 -0400
Received: from smtp.nokia.com ([192.100.122.233]:63106 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab0FPLzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:55:51 -0400
Subject: [GIT PULL] OMAP DSS fixes for 2.6.35-rc4
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 14:55:29 +0300
Message-ID: <1276689329.12438.32.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2010 11:55:30.0241 (UTC) FILETIME=[D16B6B10:01CB0D4A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these two fixes for the OMAP framebuffer driver.

 Tomi


The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
  Linus Torvalds (1):
        Linux 2.6.35-rc1

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

Janusz Krzysztofik (1):
      OMAPFB: LCDC: change update_mode to DISABLED when going suspend

Tomi Valkeinen (1):
      OMAP: OMAPFB: fix rfbi.c compile error

 drivers/video/omap/lcdc.c |   14 ++------------
 drivers/video/omap/rfbi.c |    5 +++--
 2 files changed, 5 insertions(+), 14 deletions(-)


