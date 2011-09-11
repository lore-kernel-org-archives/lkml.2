Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1IKWoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 18:44:19 -0400
Received: from lucidpixels.com ([72.73.18.11]:40432 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1IKWoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 18:44:18 -0400
Date: Sun, 11 Sep 2011 18:44:17 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>, mlin@ss.pku.edu.cn
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues?
In-Reply-To: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Sep 2011, Justin Piszcz wrote:

> Hi,
>
> With 3.0.1 now and all options compiled in and threadirqs removed, I get the 
> same error this user is seeing:
> http://www.gossamer-threads.com/lists/linux/kernel/1424997
>

Hello Lin,

I missed your mail (sender IP is in a CIDR blacklist), disabled & whitelisted 
for now:
http://marc.info/?l=linux-kernel&m=131567477126674&w=2

I've enabled this and I will post a new e-mail / output if it happens
again with debug enabled for SLAB.

Response to your e-mail:

> Could you tell how to reproduce this?
Running a lot of processes at the same time (memory/cpu+i/o)

> And would you please turn on more debug options to capture more info?
Yup, done now; however, I am using SLAB, not SLUB; so I've enabled:

-> [*] Debug slab memory allocations 
-> [*]   Memory leak debugging 
-> [*] Debug VM

> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB_DEBUG_ON=y
> CONFIG_DEBUG_VM=y

Please let me know if there are any other options you think would be useful
to enable or if this should be good, if it recurs again-- as noted above
I will post an update.

Justin.

