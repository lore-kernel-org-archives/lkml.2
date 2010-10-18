Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab0JRPt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:49:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56104 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab0JRPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pL5NUtRPNjf5eBJV5cc3DwNGJQAfvPlUoCp0E69ZAXL1LOtwiYXAxdR4dnshGv7AjH
         26f2Cy2K8cROFPow1z6giuKApKGzstgrsHi542vhhfde34+eG9nkRgYzawuiyj/jVxAe
         QpWPptYYJBGp/yEMqwdKkvPr70WlR3orhc+yE=
Date: Mon, 18 Oct 2010 08:49:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Daniel Mack <zonque@gmail.com>
Subject: [git pull] Input updates for 2.6.36-rc7
Message-ID: <20101018154941.GA5406@core.coreip.homeip.net>
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
