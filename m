Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2HYChl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 22:37:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8134 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2HYChg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 22:37:36 -0400
X-Authority-Analysis: v=2.0 cv=A87uztqG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=GY1JlanN2KIA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=rNjbT4lx8S8F5aWqB_MA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345862254.19067.0.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.2.27-rt40
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 24 Aug 2012 22:37:34 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.27-rt40 stable release.


This release is just an update to the new stable 3.2.27 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 31f85ffc3a341b9377ac66702947bbc0e5ca008d


Or to build 3.2.27-rt40 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.27.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.27-rt40.patch.xz



Enjoy,

-- Steve



