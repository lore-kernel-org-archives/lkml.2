Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab0JRQVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:21:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42414 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab0JRQVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vFkCzYeNgnA3vFp4XoIob7i5WPJXohrWTfiSotNFf5FezNmRTsTN3mLTlhlyhDJ1fp
         gWvoYSwvIGTbSmpok0Vp/2vfsbkIx7kmWX6rvUmekoUg7oVRe+B4fIAgKfg9nHiPo84q
         hKtk4QEJBjJalAGfX7JbzcN8cl4nBNJPXrJuk=
Date: Mon, 18 Oct 2010 09:20:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Daniel Mack <zonque@gmail.com>
Subject: [git pull] Input updates for 2.6.36-rc8
Message-ID: <20101018162058.GA16552@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending with the proper version in subject.]

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2 important bug fixes to the evdev input handler. I hope it
is not too late to make 2.6.36...

Changelog:
---------

Daniel Mack (2):
      Input: evdev - fix Ooops in EVIOCGABS/EVIOCSABS
      Input: evdev - fix EVIOCSABS regression


Diffstat:
--------

 drivers/input/evdev.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

Thanks,
Dmitry
