Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab1BEGcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 01:32:14 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:54989 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750988Ab1BEGcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 01:32:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18e2pBYUesedr6TVRiOiaYY0YBWeF6fmOIW5Iak+Z
	z+zXRC1HdYWXVy
Subject: Re: scheduling policy    was: Re: 2.6.37 considered stable?
From: Mike Galbraith <efault@gmx.de>
To: "Dr. Martin Rogge" <marogge@onlinehome.de>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201102042123.28734.marogge@onlinehome.de>
References: <201102042123.28734.marogge@onlinehome.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 07:32:09 +0100
Message-ID: <1296887529.27896.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 21:23 +0100, Dr. Martin Rogge wrote:
> Gene Heskett wrote:
> > Chuckle.  I've been running 2.6.37 here, with all of that new group
> > scheduling stuff enabled, the desktop feels great and my only fuss is that
> > kaffiene, when watching digital tv on my pcHD-3000 card, is NOT getting
> > enough time so both the audio and the video have little 20 millisecond
> > holes chopped in them at sub-second intervals.  Not the most pleasant
> > thing
> > to watch.  I would appreciate any suggestions on how to get such an
> > application a higher priority.
> > 
> 
> Gene, have you tried schedtool to set the scheduling policy of the process to 
> SCHED_FIFO or even SCHED_ISO?

/*
 * Scheduling policies
 */
#define SCHED_NORMAL            0
#define SCHED_FIFO              1
#define SCHED_RR                2
#define SCHED_BATCH             3
/* SCHED_ISO: reserved but not implemented yet */
#define SCHED_IDLE 

> Before anyone asks, yes, relying on schedtool puts a little reponsibility on 
> user space, but it is my firm believe that (a) you can't auto-everything and 
> (b) the onus should be on the distro not the user.

You only want to run apps RT if they really really need it though.  In
many cases, running an app RT will reduce performance, and may well
increase latencies.  (deterministic != quick like a bunny;)

	-Mike

