Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2I0WTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:19:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17470 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2I0WTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:19:52 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=a9-q7-gJKaUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=YS7ez-4iEAYA:10 a=VwQbUJbxAAAA:8 a=cfkqPTykAAAA:8 a=w5m9ts5_Bw_MLl2stG8A:9 a=PUjeQqilurYA:10 a=HEdnscJc8mAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348784389.22822.85.camel@gandalf.local.home>
Subject: [ANNOUNCE] Stable RT tarballs... Back by popular demand!!!!
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Frank Rowand <frank.rowand@am.sony.com>
Date: Thu, 27 Sep 2012 18:19:49 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I stated that I would be willing to put back the stable tarballs to
kernel.org at Linux Plumbers. Well, I finally had time to finish my
tarball script, which basically just does what the README tells you to
do:

 $ git checkout v3.4.1-rt9-rebase
 $ mkdir patches
 $ git format-patch -o patches v3.4.1
 $ ls patches > series
 $ mv series patches


And packages it all up nicely into a tarball. I will be pushing up the
tarballs as I do the rebase branches, as they are based off of the
rebase branch.

The current tarballs are:

http://kernel.org/pub/linux/kernel/projects/rt/3.0/patches-3.0.43-rt65.tar.xz

http://kernel.org/pub/linux/kernel/projects/rt/3.2/patches-3.2.30-rt45.tar.xz

http://kernel.org/pub/linux/kernel/projects/rt/3.4/patches-3.4.11-rt19.tar.xz

Enjoy,

-- Steve


