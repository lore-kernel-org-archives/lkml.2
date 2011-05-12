Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab1ELPev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:34:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38732 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab1ELPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kmMx1PKiDuCMU2ztI9OWtI6Q6Cr1OVRuCy9kz8tBC3nzSXFyYwavpovzVa2t0c9+uk
         pff/qag9sJ6ERCd9kOweighQe2CwazMA3I8G0/YbN90nhn4gwdbLeLaETochqzBiuro+
         gLS5axfXd1F770B6ilAFja/ARF6aDpNUekHto=
Date: Thu, 12 May 2011 08:34:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.39-rc7
Message-ID: <20110512153442.GA8293@core.coreip.homeip.net>
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

to receive a couple of fixups to ads7846 driver. Only the firs one is
important, the 2nd one is a cleanup but I am including it to avoid
annoying merge conflict.

Thanks!

Changelog:
---------

Alexander Stein (2):
      Input: ads7846 - make transfer buffers DMA safe
      Input: ads7846 - remove unused variable from struct ads7845_ser_req


Diffstat:
--------

 drivers/input/touchscreen/ads7846.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

-- 
Dmitry

