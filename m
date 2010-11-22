Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab0KVCSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:18:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0KVCSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:18:39 -0500
Date: Sun, 21 Nov 2010 18:16:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc3 (fixmap build error)
Message-Id: <20101121181655.4996cdde.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com>
References: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 15:43:18 -0800 Linus Torvalds wrote:

> Another week, another -rc.
> 
> And I have to say, I'm pretty happy with how quiet things have been.
> Of course,  maybe people are just lying low, waiting to ambush me next
> week with a flood of patches when I'm gone in Japan, all in order to
> try to be inconvenient. Because that's the kind of people kernel
> developers are.
> 
> But I'm going to just keep my fingers crossed, and hope that this
> means a calm release schedule. The fairly small ShortLog is appended,
> and looking at the dirstat, about 75% of the changes are to drivers
> (which is fairly normal), and over half of that is the DRM updates
> (which is higher than normal, and apparently brought on by everybody
> else being so quiet).


I thought that I saw a patch for this one, but I can't find it now.

on i386:
arch/x86/built-in.o: In function `fix_to_virt':
/usr/builds/linux-2.6.37-rc3/arch/x86/include/asm/fixmap.h:207: undefined reference to `__this_fixmap_does_not_exist'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
