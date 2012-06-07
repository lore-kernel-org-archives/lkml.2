Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766Ab2FGNkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:40:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5066 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2FGNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:39:59 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=oioPlalLgeHcZa3h1WIA:9 a=PUjeQqilurYA:10 a=AqiG5UHJQZRIOjvh:21 a=iaoldVFnlvHl06ue:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339076397.7559.4.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.4.1-rt9
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 07 Jun 2012 09:39:57 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.1-rt9 stable release.


This release is just an update to the new stable 3.4.1 version
and no RT specific changes have been made.

(one exception: commit 24312d34 workqueue: skip nr_running sanity check in worker_enter_idle() if trustee is active
  has been reverted. Thanks to Ibrahim Umar for pointing out the
  build failure. The commit was to remove a triggering of a false
  WARN_ON, but it required variables that did not exist in the -rt
  workqueue version. Hopefully we do not see this false positive.)


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 0ccbbea2d9b1253eaae376df58705bfd11d0028f


Or to build 3.4.1-rt9 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.1.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.1-rt9.patch.xz



Enjoy,

-- Steve



