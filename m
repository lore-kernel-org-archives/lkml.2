Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0JGFqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 01:46:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45788 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0JGFqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 01:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ck/dQDcLEpACoRQP0PjiJNCun3UeICAhTkJnGSPtETyR3FTay953djavAbv+p3l4W0
         vxBzSCTri3VyNAgsLj5GlbJwLkBjMW06qm9hA87DTPY6pvAXe3B372DxerWrqfxEvNxk
         Tta2+RqKpS347sqCau3zqmXWvNGv4vZLS+0Kg=
Date: Wed, 6 Oct 2010 22:46:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.36-rc7
Message-ID: <20101007054641.GA23485@core.coreip.homeip.net>
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

to receive updates for the input subsystem. I sat on these a little bit
too long but I believe 2.6.36 will be better with these fixes.

Changelog:
---------

Dmitry Torokhov (1):
      Input: wacom - fix runtime PM related deadlock

Henrik Rydberg (1):
      Input: uinput - setup MT usage during device creation

Kenneth Waters (1):
      Input: joydev - fix JSIOCSAXMAP ioctl


Diffstat:
--------

 drivers/input/joydev.c           |    3 +++
 drivers/input/misc/uinput.c      |    7 +++++++
 drivers/input/tablet/wacom_sys.c |   23 ++++++++++++-----------
 3 files changed, 22 insertions(+), 11 deletions(-)

