Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab0KAKSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 06:18:12 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:49231 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab0KAKSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 06:18:11 -0400
Date: Mon, 1 Nov 2010 11:18:09 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: [git pull] CRISv10 RS485 serial fixes
Message-ID: <20101101101809.GI5043@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

Please pull the below repository, it contains some small changes
for CRIS RS485 handling and changes so the CRISv10 serial driver
is mentioned under the CRIS section in MAINTAINERS.

Thanks!


The following changes since commit b5153163ed580e00c67bdfecb02b2e3843817b3e:

  Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm (2010-10-21 16:42:32 -0700)

are available in the git repository at:

  git://www.jni.nu/cris.git for-linus

Jesper Nilsson (3):
      Add missing "struct" to in sizeof.
      CRIS: Fix RS485 delay handling.
      CRIS: Add paths for CRISv10 serial driver

 MAINTAINERS              |    1 +
 drivers/serial/crisv10.c |   23 +++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
