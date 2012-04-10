Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab2DJT5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:57:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890Ab2DJT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:57:05 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=09QRHktL8YSMekdywXYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334087822.23924.228.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.14-rt24
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 10 Apr 2012 15:57:02 -0400
In-Reply-To: <alpine.LFD.2.02.1204101638180.2542@ionos>
References: <alpine.LFD.2.02.1204101638180.2542@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 16:42 +0200, Thomas Gleixner wrote:

> This is my last release based on 3.2. I'm handing the 3.2-rt series
> over to Steven and move on to 3.4.

The branch v3.2-rt has been created in:

   git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

It starts with v3.2.14-rt24 with the patches broken out on top of
v3.2.14.

New releases for v3.2-rt will now be kept in this branch and patch files
will be produced similar to the way the v3.0-rt tree is maintained.

This branch will never rebase, and new mainline stable releases will be
merged into this branch. Fixes will be applied on top of the branch. I
will also create a v3.2-rt-rebase branch (and tags) that will allow you
to make broken out patches (like v3.0-rt-rebase) as long as time permits
me to do so.

-- Steve


