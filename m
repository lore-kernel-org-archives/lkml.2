Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2LTUnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:43:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2LTUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:43:04 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=tjAbNFExH_XZehE1hscA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356036181.5896.58.camel@gandalf.local.home>
Subject: [ANNOUCE] 3.4.24-rt35
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 20 Dec 2012 15:43:01 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

Note, I have abandoned the original 3.4.22-rt34 release due to a
reported bug in the -rc candidate. I will be applying a new rc release
based off of this release.

I'm pleased to announce the 3.4.24-rt35 stable release.


This release is just an update to the new stable 3.4.24 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 3636684d50746ce56373ca20b438e3d2e7f9aca9


Or to build 3.4.24-rt35 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.24.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.24-rt35.patch.xz



Enjoy,

-- Steve



