Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0JaP2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 11:28:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49993 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0JaP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 11:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=s4UYNYQVaNSRuG4iv89ZfOWtMD16BcvJHZBMTHm/avWbVqp3Wt652thjN0GMKtKucg
         JP2WIUB2gYLqdEyigbbUVClSevi0vw3a1BBj30mb/hV+r6jYyK4Aop3Bi4cTE6RXNQwf
         Zymmkjt3GXNUY+8v4T7S4jV57R+I2wZL/JtTE=
Date: Sun, 31 Oct 2010 08:28:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.37-rc0
Message-ID: <20101031152831.GA1101@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dan Carpenter (1):
      Input: bu21013_ts - fix null dereference in error handling

Joe Perches (1):
      Input: appletouch - remove extra KERN_DEBUG use from dprintk

Michael Hennerich (1):
      Input: ad7879 - prevent invalid finger data reports


Diffstat:
--------

 drivers/input/mouse/appletouch.c       |    2 +-
 drivers/input/touchscreen/ad7879.c     |   32 +++++++++++++++++++++++++++-----
 drivers/input/touchscreen/bu21013_ts.c |    2 +-
 3 files changed, 29 insertions(+), 7 deletions(-)

-- 
Dmitry

