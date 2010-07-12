Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0GLP4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:56:46 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:56215 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0GLP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:56:45 -0400
Message-ID: <4C3B3B39.2000809@davidnewall.com>
Date: Tue, 13 Jul 2010 01:26:41 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Marcin Letyns <mletyns@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de>	<20100711131640.GA3503@thunk.org>	<4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com>
In-Reply-To: <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin,

>> I don't expect fair consideration of these comments; why change when
>> shooting the messenger is so much more satisfying?
>>     
Q.E.D.


First, for the sake of brevity, I want it agreed that we're talking 
about new kernels, not those which are old, time-tested and patched.

I didn't notice anyone say they want Linux development to slow down; 
rather, and not just in this thread but in many threads before, that 
kernels released as "stable" fail to meet the common meaning of that 
word; and this needs to be improved.  Predictably, the common response 
sounds a bit like "shut up, go away, you're an idiot, it doesn't happen 
to me."  These are not useful as they serve not one whit to improve the 
situation, but give pause to those who might otherwise want to bring up 
a valid issue, once more.

Expectations are key to the problem.  When Linus says, "here is a shiny 
new, stable kernel", he creates expectations.  When that kernel proves 
unstable, those expectations are dashed and confidence in Linux 
suffers.  There's no reason why development methods need to change in 
order to reduce the number of flaky "stable" kernels.  It would be 
sufficient to replace the somewhat deceptive word "stable" with one that 
is more accurate; beta or gamma test make sense as they already have 
industry acceptance.  Clearly "stable" is not appropriate, as implicitly 
agreed by others who have advised: "don't use in production"; "wait at 
least a year"; and more.

Thus 2.6.34 is the latest gamma-test kernel.  It's not stable and I 
doubt anybody honestly thinks otherwise.

As to whether other operating systems are stable, well that's a fair 
question.  I agree that few large bodies of computer code are flawless, 
and so stability can be relative.  In that spirit I venture to put the 
stipulated kernels into order of decreasing reliability: Best is BSD, 
Solaris & OS X; then Windows; and then there's Linux.  If named 
distributions had been included, the list would look better (for us); 
they'd go in the first group.  Thank goodness for the Debian, Red Hat 
and Novell (to name just a few) for giving the world something which 
does, at least largely, meet expectations.
