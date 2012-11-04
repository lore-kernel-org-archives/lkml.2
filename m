Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2KDMlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 07:41:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:36302 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750986Ab2KDMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 07:41:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/mqd9Ksl7mnUD93Tf2uyl3d5owZrvS0Ydbrv8Sm5
	cTJ+ncDwaumdq0
Message-ID: <1352032908.8944.34.camel@maggy.simpson.net>
Subject: Re: Scheduler queues for less os-jitter?
From: Mike Galbraith <efault@gmx.de>
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 04 Nov 2012 05:41:48 -0700
In-Reply-To: <op.wm8r8fjw6426ze@localhost.localdomain>
References: <op.wly58nr56426ze@localhost.localdomain>
	 <1349923594.6989.19.camel@marge.simpson.net>
	 <op.wm75y11n6426ze@localhost.localdomain>
	 <op.wm8r8fjw6426ze@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-04 at 10:20 +0100, Uwaysi Bin Kareem wrote: 
> Ok, anyway realtime processes did not work quite as expected.  
> ("overloaded" machine, even though cpu-time is only 10%). So I guess I  
> have to enable cgroups and live with the overhead then.
> 
> If I set cpu-limits there, does that involve an absolute value, or is it  
> normalized, so that even if I do 0.001% cpu for processes, they get all  
> cpu, when there is nothing running?

See Documentation/cgroups.  Between cgroups, cpusets, scheduler classes
and priorities, you have heaping truckloads of control over what runs
where and when.  The missing element in your low jitter quest is a
desktop and applications that were written for realtime performance.

-Mike

