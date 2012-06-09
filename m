Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2FIMoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 08:44:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23142 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2FIMoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 08:44:14 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=NfCaXVXfj-EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=SVpVqYEkgjDRaienuYwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339245852.13377.71.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/3 v2] [GIT PULL][3.6] x86: cr2 and cmpxchg issues of
 NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 09 Jun 2012 08:44:12 -0400
In-Reply-To: <4FD2EDFD.1060508@zytor.com>
References: <20120609020257.248773533@goodmis.org>
	 <1339210729.13377.68.camel@gandalf.stny.rr.com>
	 <4FD2EDFD.1060508@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 23:32 -0700, H. Peter Anvin wrote:

> Hm... actually it looks more like you reused an old branch and forgot to
> actually push it out.

Actully, I pushed it out, I just forgot to check to see if it succeeded:

error: failed to push some refs to 'gitolite@ra.kernel.org:/pub/scm/linux/kernel/git/rostedt/linux-trace.git'
To prevent you from losing history, non-fast-forward updates were rejected
Merge the remote changes (e.g. 'git pull') before pushing again.  See the
'Note about fast-forwards' section of 'git push --help' for details.

This is also why I include the HEAD SHA1 in my pull messages ;-)

Force pushed just made.

Thanks,

-- Steve


