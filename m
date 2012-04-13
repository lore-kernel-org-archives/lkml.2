Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2DMRDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:03:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52765 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755486Ab2DMRDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:03:10 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/TFg9j5nzTlgeKOuIQPxMeSXu5xwisJAiTV+yrSt
	Fd55upDQdV6wI/
Message-ID: <4F885C42.2000405@gmx.de>
Date: Fri, 13 Apr 2012 17:02:58 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the fixes below. The fix for kyrofb is a bit large but it's just
replacing "unsigned long" by "u32" for 64 bit compatibility.


Thanks,

Florian Tobias Schandinat


The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-fixes-for-3.4-1

for you to fetch changes up to b78f29ca0516266431688c5eb42d39ce42ec039a:

  video:uvesafb: Fix oops that uvesafb try to execute NX-protected page
(2012-04-09 16:05:57 +0000)

----------------------------------------------------------------
fbdev fixes for 3.4

It includes:
- a compile fix for au1*fb
- a fix to make kyrofb usable on x86_64
- a fix for uvesafb to prevent an oops due to NX-protection

----------------------------------------------------------------
Manuel Lauss (1):
      fbdev: fix au1*fb builds

Ondrej Zary (1):
      kyrofb: fix on x86_64

Wang YanQing (1):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page

 drivers/video/au1100fb.c        |    5 +-
 drivers/video/au1200fb.c        |    2 +-
 drivers/video/kyro/STG4000Reg.h |  376 +++++++++++++++++++-------------------
 drivers/video/uvesafb.c         |   11 +-
 4 files changed, 201 insertions(+), 193 deletions(-)
