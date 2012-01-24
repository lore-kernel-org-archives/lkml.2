Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2AXVqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:46:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2AXVqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:46:50 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=kI3nox531dwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=shE0knAXhmhOz9LbWlQA:9 a=XxVNJYOrRjDjfdKoFJgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327441608.22710.35.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] New stable 3.0-rt-rebase branch at
 git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Clark Williams <clark@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Tue, 24 Jan 2012 16:46:48 -0500
In-Reply-To: <1327423516.22710.31.camel@gandalf.stny.rr.com>
References: <1327423516.22710.31.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 11:45 -0500, Steven Rostedt wrote:

> $ git tag | grep -- -rt
> v3.0.10-rt27
> v3.0.10-rt27-rebase
> v3.0.11-rt28
> v3.0.11-rt28-rebase
> v3.0.12-rt29
> v3.0.12-rt29-rebase
> v3.0.12-rt30
> v3.0.12-rt30-rebase
> v3.0.14-rt31
> v3.0.14-rt31-rebase
> v3.0.14-rt32
> v3.0.14-rt32-rebase
> v3.0.17-rt33
> v3.0.17-rt33-rebase
> v3.0.9-rt25
> v3.0.9-rt26
> 

As I found out by testing what was pushed and not seeing what I expected
and going crazy in the mean time, I've discovered (thanks to the guys on
Freenode #git) that tags of commits that are not associated to any
branch (like these are) will not be pulled with a normal "git fetch" or
"git remote update".


You need to do a "git fetch --tags" to get the tags for the rebases that
are no long part of the v3.0-rt-rebase branch.

-- Steve


