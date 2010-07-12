Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0GLT6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:58:21 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:32905 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0GLT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:58:19 -0400
Message-ID: <4C3B73D7.8050802@davidnewall.com>
Date: Tue, 13 Jul 2010 05:28:15 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Marcin Letyns <mletyns@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de>	<20100711131640.GA3503@thunk.org>	<4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com> <4C3B3B39.2000809@davidnewall.com> <4C3B585A.6090106@s5r6.in-berlin.de>
In-Reply-To: <4C3B585A.6090106@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> David Newall wrote:
>   
>> Thus 2.6.34 is the latest gamma-test kernel.  It's not stable and I
>> doubt anybody honestly thinks otherwise.
>>     
>
> It works stable for what I use it for.
>   
Mea culpa.  I didn't mean that 2.6.34 is unstable, but that the term 
"stable" is not appropriate for a newly released kernel; "gamma" should 
be used instead.

Merely six months ago 2.6.32 was released; today we're preparing for 
2.6.35; a new kernel every two months!  Perhaps 2.6.31 is truly the 
latest stable kernel; or else 2.6.27 does, which is the other 2.6 on the 
front page of kernel.org.  I'm pretty sure 2.4 is stable (which might 
explain why I see it embedded *much* more frequently than 2.6.)

> If it doesn't for you, then I hope you are already in contact with the
> respective subsystem developers to get the regressions that you
> experience fixed.
>   
(Segue to a problem which follows from calling bleeding-edge kernels 
"stable".)

When reporting bugs, the first response is often, "we're not interested 
in such an old kernel; try it with the latest."  That's not hugely 
useful when the latest kernels are not suitable for production use.  If 
kernels weren't marked stable until they had earned the moniker, for 
example 2.6.27, then the expectation of developers and of users would be 
consistent: developers could expect users to try it again with latest 
stable kernel, and users could reasonably expect that trying it wouldn't 
break their system.
