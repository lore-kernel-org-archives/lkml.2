Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2FFVSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:18:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2FFVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:18:08 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=oioPlalLgeHcZa3h1WIA:9 a=PUjeQqilurYA:10 a=_jmfxP3KFCXnpc18:21 a=QbXv9zc3RogYTjc5:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339017485.13348.555.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.2.19-rt30
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 06 Jun 2012 17:18:05 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.19-rt30 stable release.


This release is just an update to the new stable 3.2.19 version
and no RT specific changes have been made.

(one exception: commit 5d79c6f6 workqueue: skip nr_running sanity check in worker_enter_idle() if trustee is active
  has been reverted. Thanks to Ibrahim Umar for pointing out the
  build failure. The commit was to remove a triggering of a false
  WARN_ON, but it required variables that did not exist in the -rt
  workqueue version. Hopefully we do not see this false positive.)


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: a0fea1c718c2cd7b168c355e8febe9e670099558


Or to build 3.2.19-rt30 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.19.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.19-rt30.patch.xz



Enjoy,

-- Steve



