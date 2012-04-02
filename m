Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2DBJA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:00:26 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:38298 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab2DBJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:00:04 -0400
X-Greylist: delayed 1358 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2012 05:00:04 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20345.25923.713396.391580@pilspetsen.it.uu.se>
Date: Mon, 2 Apr 2012 10:37:23 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Berto <berto37@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Kernel oops 805 running Debian on Qnap TS-119PII
In-Reply-To: <CAJ6tnsJKt2rb0wq1vh+RReF-0sAWJijKavjYOhC39cc3Nc6EFQ@mail.gmail.com>
References: <CAJ6tnsJKt2rb0wq1vh+RReF-0sAWJijKavjYOhC39cc3Nc6EFQ@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Berto writes:
 > Not sure if this is where to send this; please forward to the right people.

The ARM kernel developers tend to use linux-arm-kernel@lists.infradead.org
rather than the ordinary lkml.  However, since you're apparently running a
kernel provided by Debian, you should send the bug report to Debian first.

 > Description: I am running Debian squeeze on my Qnap TS-119PII. I used
 > the installer by Martin Michlmayr (cyrius.com). No exotic packages
 > installed, just the ordinary openssh, samba, afp and apache. All seems
 > to run fine until, once or twice a day, the systems crashes, rendering
 > it unreachable on all ports (even ping). I am often pumping lot's of
 > files in it through samba, but I am not sure that is the cause of evil here.
 > 
 > Keywords: kernel oops 805 samba
 > 
 > #cat /proc/version
 > Linux version 2.6.32-5-kirkwood (Debian 2.6.32-41squeeze2)
 > (dannf@debian.org) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 Fri Mar 23
 > 07:59:47 UTC 2012

FWIW, I've run self-compiled kernels on Qnap TS-119 and TS-119P+ for years
under very heavy CPU and local file system loads, and they've always been
extremely solid.  It's possible that your networking/samba load is triggering
something bad.

Also I'd strongly recommend building the kernel with gcc-4.6.3, lots of bugs
have been fixed since the now obsolete and unsupported gcc-4.3.

/Mikael
