Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1HCUX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:23:27 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:56306 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab1HCUXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:23:23 -0400
Subject: Re: [PATCH 00/11] RFC: KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <201105171050.38903.florian@openwrt.org>
Date: Wed, 3 Aug 2011 21:23:19 +0100
Cc: Jonathan Corbet <corbet@lwn.net>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Linux-embedded" <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <B8A97132-FADB-4476-8386-16FB5900D47F@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net> <201105171050.38903.florian@openwrt.org>
To: Florian Fainelli <florian@openwrt.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17 May 2011, at 09:50, Florian Fainelli wrote:

> Sorry for this late answer.

And apologies for my own late response. I'll try to keep this short as
I hope the "Restatement" side-thread will address some of it.

> On Tuesday 22 March 2011 20:36:40 Jonathan Corbet wrote:
>> 
>> - Why kbus over, say, a user-space daemon and unix-domain sockets?  I'm
>>  not sure I see the advantage that comes with putting this into kernel
>>  space.
> 
> I also fail to see why this would be required. In my opininon you are trading 
> the reliability over complexity by putting this in the kernel.

I hope that's addressed in the "So why did we write it as a kernel
module?" section of the "Restatement" message thread. Basically,
I believe a kernel module is smaller and "steals" reliability from
code written and tested by others. That doesn't mean it's a good
solution "in the wild", of course (privately we can add whatever we
want to the kernel, but in public it is and must be controlled).

> Indeed, I would also suggest having a look at what generic netlink already 
> provides like messages per application PID, multicasting and marshaling. If 
> you intend to keep a part of it in the kernel, you should have a look at this, 
> because from my experience with generic netlink, most of the hard job you are 
> re-doing here, has already been done in a generic manner.

If we do end up heading that way, I hope you won't mind if I ask
you for advice!

All the best,
	Tibs

