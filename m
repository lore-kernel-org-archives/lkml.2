Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab0EZBq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:46:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759143Ab0EZBq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:46:27 -0400
Date: Tue, 25 May 2010 18:46:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harald Dunkel <harald.dunkel@aixigo.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.34 on Samsung P460: reset after
 "Waiting for /dev to be fully populated"
Message-Id: <20100525184621.89487735.akpm@linux-foundation.org>
In-Reply-To: <4BFB947E.9080509@aixigo.de>
References: <4BFB947E.9080509@aixigo.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 11:12:30 +0200 Harald Dunkel <harald.dunkel@aixigo.de> wrote:

> Hi folks,
> 
> Problem: At boot time I see a final message
> 
> 	Waiting for /dev to be fully populated
> 
> then my laptop (Samsung P460) does a reset. The next
> boot doesn't work, so I have to power-cycle the laptop.
> 
> If I boot with "acpi=off", then 2.6.34 gets stuck instead.
> The last 2 lines are
> 
> 	TCP reno registered
> 	Net: Registered protocol family 1
> 
> Any helpful comment would be highly appreciated.
> 

ow, hard.

I assume that the "Waiting for /dev to be fully populated" comes from
udev?  Greg, do you know what might trigger that?

Harald, I think the best (only?) way to fix this is for you to do a
bisection search.  http://landley.net/writing/git-quick.html has some
instructions.

It's a bit of a pain to do, sorry.
