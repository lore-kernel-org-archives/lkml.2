Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1I3J6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:58:38 -0400
Received: from lucidpixels.com ([72.73.18.11]:56996 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab1I3J6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:58:37 -0400
Date: Fri, 30 Sep 2011 05:58:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Harald Dunkel <harri@afaics.de>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched_state detected stall on CPU 6
In-Reply-To: <4E857E10.3030103@afaics.de>
Message-ID: <alpine.DEB.2.02.1109300557510.8036@p34.internal.lan>
References: <4E857E10.3030103@afaics.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 30 Sep 2011, Harald Dunkel wrote:

> Hi folks,
>

This is a known bug, upgrade to 3.1-rc8 and your problem should go away, I 
had the same problem with 3.0.4 (amd64)

kern.log:Sep 11 18:11:43 p34 kernel: [26902.879347] INFO: rcu_sched_state 
detected stall on CPU 20 (t=60000 jiffies)

Justin.

