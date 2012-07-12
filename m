Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab2GLIoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:44:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40539 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758923Ab2GLIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:44:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX196aOclgeV6qKbjtH+LcUG/dM5QZPy1alNy8r300X
	fHuz2apdCmaGSJ
Message-ID: <1342082648.7338.171.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 12 Jul 2012 10:44:08 +0200
In-Reply-To: <1342072060.7338.102.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 07:47 +0200, Mike Galbraith wrote: 
> Greetings,
> 
> I'm chasing btrfs critters in an enterprise 3.0-rt kernel, and just
> checked to see if they're alive in virgin latest/greatest rt kernel.  
> 
> Both are indeed alive and well, ie I didn't break it, nor did the
> zillion patches in enterprise base kernel, so others may have an
> opportunity to meet these critters up close and personal as well.

3.2-rt both explodes and deadlocks as well.  3.0-rt (virgin I mean) does
neither, so with enough re-integrate investment, it might be bisectable.

Rummaging in btrfs, that begins to look down right attractive ;-)

-Mike

