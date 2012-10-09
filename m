Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2JIACl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:02:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4497 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2JIACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:02:38 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=jUj6k1thcyF8JFCVi34A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349740957.24256.2.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.0.44-rt66
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Mon, 08 Oct 2012 20:02:37 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.44-rt66 stable release.


This release is just an update to the new stable 3.0.44 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 7742bd1d93ff89a4bd01e704e031bd8569b201d3


Or to build 3.0.44-rt66 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.44.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.44-rt66.patch.xz



Enjoy,

-- Steve



