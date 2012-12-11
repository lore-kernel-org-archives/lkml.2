Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2LKRKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:10:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2LKRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:10:20 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=96tAAt3syKLdGtijk-8A:9 a=PUjeQqilurYA:10 a=rS2DEZrQZILjt5f5:21 a=1IHrFDR6NzGFaUC8:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355245818.17101.301.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.2.35-rt52
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 11 Dec 2012 12:10:18 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.35-rt52 stable release.


This release is just an update to the new stable 3.2.35 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: d441aa892288a10a4e8bfcd0926068ce2ac2236c


Or to build 3.2.35-rt52 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.35.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.35-rt52.patch.xz



Enjoy,

-- Steve



