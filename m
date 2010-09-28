Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0I1X3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:29:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39533 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751568Ab0I1X3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:29:35 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18p20M2oPcpZ79B6GhkT0auY0BVkDTN/r/aMzGqDQ
	e5XRZl4S6QOWyO
Date: Wed, 29 Sep 2010 01:29:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Raymond Liu <raymondliu3linux@gmail.com>
cc: Ben Gamari <bgamari@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: HDMI open source to handle audio/video/CEC in one driver
In-Reply-To: <AANLkTikxzY9KP2zzQ+pXN0t_5Z4L7kHyd_Xz5fD+GcZn@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1009290115500.15162@axis700.grange>
References: <AANLkTimMH604FW_NZehY68w8B_cV_Lhe-ZwZq0cAYUfd@mail.gmail.com>
 <AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com>
 <Pine.LNX.4.64.1009281624100.11083@axis700.grange>
 <AANLkTikxzY9KP2zzQ+pXN0t_5Z4L7kHyd_Xz5fD+GcZn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Raymond Liu wrote:

> Hi Ben and Guennadi,
> 
> Really appreciate your inputs.
> 
> For temporarily short term purpose (we already had a driver but it did
> not fit into any of these you mentioned), what is the process we
> should follow to make it an "open source"?

Sorry, do not understand: if it didn't fit into any of these categories, 
what is it like? In any case, general instructions you find in the 
following files in your Linux kernel sources directory:

Documentation/SubmitChecklist
Documentation/SubmittingPatches
Documentation/SubmittingDrivers
Documentation/CodingStyle

I know, it might seem a lot, but take a bit of time to look through them, 
not everything will be 100% relevant to each specific case, but do follow 
Documentation/CodingStyle and choose a suitable mailing list for your 
posts - this list (LKML) is too gneric for your questions, that's why 
you're getting so few to-the-topic replies.

And I'm not sure what you mean by "temporarily short term purpose." As 
soon as your driver gets into the kernel, it is better, if it is designed 
to stay there for a longer time. It might not be perfect from the very 
first version, its functionality might be restricted, but for that little, 
that it does, it should already adhere to the kernel standards. You might 
also consider adding your driver under drivers/staging - if you're unable 
to follow the guidelines and want to give your driver more exposure to 
gradually fix it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
