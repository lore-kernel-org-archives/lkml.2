Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2CVTAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:00:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59754 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751341Ab2CVTAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:00:30 -0400
Message-ID: <1332442828.5636.39.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jiri Slaby <jslaby@suse.cz>, Phil Carmody <ext-phil.2.carmody@nokia.com>,
        apw@canonical.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Date: Thu, 22 Mar 2012 12:00:28 -0700
In-Reply-To: <6258.1332436627@turing-police.cc.vt.edu>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <4F6B51C9.6010904@suse.cz> <4517.1332434943@turing-police.cc.vt.edu>
	 <4F6B598A.7090909@suse.cz> <6258.1332436627@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 13:17 -0400, Valdis.Kletnieks@vt.edu wrote:
> Those can be 'int foo(void)' can't they?  The other historical usage is for
> 'int foo()' to denote an old K&R-style varargs list, which is like disco - a
> bad idea from long agon that's never coming back. ;)
> 
> Of course, if we add this to checkpatch, we'll have a flood of fixup patches.

Not really, more like a mist than a flood.
There just aren't many in-kernel uses.
There are 10 in drivers/, 15 in arch/, none in include/

$ grep -rP --include=*.[ch] "^\w+\s+\w+\s*\(\s*(?:\.\.\.){0,1}\s*\)" *

A single trivial patch should work for all of them.

> Maybe we just need to say "3.5 will be the int foo() housecleaning release" and
> be done with it?

Sensible.

