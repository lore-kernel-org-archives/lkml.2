Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1BQO3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:29:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38308 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1BQO3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:29:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 17 Feb 2011 15:28:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, gregkh@suse.de,
        srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
Message-ID: <20110217152830.427bb351@stein>
In-Reply-To: <1297935668.5411.21.camel@marge.simson.net>
References: <12978046423644@kroah.org>
	<1297810967.23343.122.camel@gandalf.stny.rr.com>
	<1297821667.5126.11.camel@marge.simson.net>
	<20110216082559.GA16529@elte.hu>
	<4D5B90E8.6080605@gmail.com>
	<1297849553.5275.29.camel@marge.simson.net>
	<20110216152906.75d4000c@stein>
	<1297919107.6361.59.camel@marge.simson.net>
	<20110217085219.417ba829@stein>
	<1297935668.5411.21.camel@marge.simson.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17 Mike Galbraith wrote:
> On Thu, 2011-02-17 at 08:52 +0100, Stefan Richter wrote:
> > > > then the solution is to /stay close enough to the mainline/.
> > 
> > [By which I meant updating, not backporting.]
> 
> [but you know that ain't an option too]

Could be disputed for any use case in which performance backports are an
option in the first place.
-- 
Stefan Richter
-=====-==-== --=- =---=
http://arcgraph.de/sr/
