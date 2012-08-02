Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2HBWmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:42:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2HBWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:42:22 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=m4U3AEEn_65mWyvU2BsA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343947340.27983.102.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.2.24-rt38
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, john stultz <johnstul@us.ibm.com>
Date: Thu, 02 Aug 2012 18:42:20 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.24-rt38 stable release.

Note, there were some non-trivial conflicts with leap-second backports.
I believe I solved them correctly (and added a change to convert
read_seqbegin to read_seqcount_begin() in ktime_get_update_offsets()).

This release passed all my internal tests, but test it out anyway, and
let me know if something fails for you.

This release is an update to the new stable 3.2.24 version. Some fixes
to the stable code (mentioned above) had to be done.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 860793bbc278575a33695cf1baa67be900f159ef


Or to build 3.2.24-rt38 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.24.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.24-rt38.patch.xz



Enjoy,

-- Steve



