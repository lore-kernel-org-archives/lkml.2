Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1JKMpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:45:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1JKMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:45:40 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XVzCnAS-rJtFtI2rsK4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Commits missed for stable
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Date: Tue, 11 Oct 2011 08:45:38 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318337139.7904.170.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's come to my attention that a bug that was fixed by:

43dd61c9a09bd413e837df829e6bfb42159be52a
ftrace: Fix regression of :mod:module function enabling


Exists in the -rt kernel. As the -rt kernel is based off of 3.0.6, this
means that the bug also exists in the stable tree. Without the fix, the
kernel will crash if the root user tries to use the :mod: functionality
of ftrace.

I also believe that the commit:


f7bc8b61f65726ff98f52e286b28e294499d7a08
ftrace: Fix regression where ftrace breaks when modules are loaded

is missing from both stable and -rt as well.

Greg, can you add the above two commits to the stable branch.

Thomas, you may want to add these to -rt, or wait till 3.0.7 comes out.

-- Steve


