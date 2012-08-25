Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2HYDI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:08:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2HYDIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:08:25 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5bEX09lj5eIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=XHp6WIcgSgEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=rNjbT4lx8S8F5aWqB_MA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345864104.19067.5.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.2.28-rt41 (this is for real)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 24 Aug 2012 23:08:24 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.28-rt41 stable release.


This release is just an update to the new stable 3.2.28 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 31f85ffc3a341b9377ac66702947bbc0e5ca008d


Or to build 3.2.28-rt41 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.28.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.28-rt41.patch.xz



Enjoy,

-- Steve



