Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2BVBdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:33:00 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49878 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2BVBc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:32:58 -0500
Date: Tue, 21 Feb 2012 17:32:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Large slowdown with 'x86: Avoid invoking RCU when CPU is idle'
Message-ID: <20120222013252.GZ2375@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120222011652.GE23186@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222011652.GE23186@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022201-7282-0000-0000-000006BA4F8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 08:16:53PM -0500, Josh Boyer wrote:
> Hi Paul,
> 
> Over in Fedora land, I applied your patch from this thread:
> 
> https://lkml.org/lkml/2012/1/24/441
> 
> to our 3.3-rc3/rc4 based rawhide kernels.  The intention was to solve an
> RCU issue that was very similar to what Eric originally reported, and
> the RCU splat did indeed go away[1].
> 
> However, we then got a few reports of kernels containing that patch
> being extremely slow.  When the patch was dropped, the slowness goes
> away according to one reporter.  The details can be found in this bug:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=795050
> 
> The slowness doesn't seem to hit everyone, and in my local testing
> things seem to be working just fine.  The reporters have widely varying
> hardware as well, so it doesn't seem machine specific.
> 
> Perhaps I misdiagnosed the original issue, or perhaps I missed something
> else that needs to be applied prior to this but I thought I would point
> this out in case you had any ideas.

This patch has been obsoleted by patches #45-47 in this series:

	https://lkml.org/lkml/2012/2/3/459

And patch #47 in that series has been obsoleted by another series
from Steven Rostedt:

	https://lkml.org/lkml/2012/2/7/231

Hopefully these fix both splats and slowness.

							Thanx, Paul

> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=789641
> 

