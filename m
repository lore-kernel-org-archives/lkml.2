Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab1ECBo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:44:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38113 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab1ECBoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EJnr3JxWGNchP/s/gIEp4MPP05XRJ2Pg+5qbxhZEi5a1AqHIdwoPIvwHNS4L0yj5RQ
         CxLtgX4RFHX0d48btjd31W0G3Ar+4RS1kZEeSjhGTMYbNUYA5VlBzdIocTVWfzoR1xNP
         IxswAQr9lV39qrd5lK5Vtp6AZ3yxCzsvQELlE=
Date: Mon, 2 May 2011 18:43:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.39-rc5
Message-ID: <20110503014359.GA22278@core.coreip.homeip.net>
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

to receive updates for the input subsystem. You will get some final
adjustments for the newly introduced wm831x-ts driver.

Thanks!

Changelog:
---------

Mark Brown (3):
      Input: wm831x-ts - fix races with IRQ management
      Input: wm831x-ts - allow IRQ flags to be specified
      Input: wm831x-ts - move BTN_TOUCH reporting to data transfer


Diffstat:
--------

 drivers/input/touchscreen/wm831x-ts.c |   75 ++++++++++++++++++++++++++++-----
 include/linux/mfd/wm831x/pdata.h      |    2 +
 2 files changed, 66 insertions(+), 11 deletions(-)

-- 
Dmitry

