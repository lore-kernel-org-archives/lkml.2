Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab0JVRg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:36:28 -0400
Received: from lo.gmane.org ([80.91.229.12]:36066 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab0JVRg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:36:27 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: On Linux numbering scheme
Date: Fri, 22 Oct 2010 13:36:10 -0400
Message-ID: <i9si2a$gcv$1@dough.gmane.org>
References: <18536664.253751287691209904.JavaMail.root@mail-zbox20.bo3.lycos.com> <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com> <AANLkTimqNW7zArcjtOkBvrn-dk=YE0_RG+u3yoMDTjwV@mail.gmail.com> <20101022020006.GF19804@ZenIV.linux.org.uk> <20101022095333.GA10047@fysh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: pool-141-149-14-139.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100825 Lightning/1.0b2 SeaMonkey/2.0.7
In-Reply-To: <20101022095333.GA10047@fysh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Athanasius wrote:
> On Fri, Oct 22, 2010 at 03:00:06AM +0100, Al Viro wrote:
>> On Thu, Oct 21, 2010 at 07:06:23PM -0500, kevin granade wrote:
>>
>>> Any particular reason not to continue the date-oriented format and
>>> have the third number be the numerical representation of the month
>>> rather than an incrementing numbering of the releases?  It would still
>>> be monotonically increasing, which is the only requirement, right?
>>
>> Why do we need to change it, anyway?
>
>    /agree
>
>    For the most part it's only distribution maintainers that see or care
> about the kernel version number anyway.  Anyone else knows what they're
> getting into if they compile a kernel themselves, and otherwise is more
> likely to say they're using "Linux 10.10" right now ....
>
>    Having said that I had a lovely suggestion in the last round on this
> topic which would allow you to know when a kernel was released just from
> its version number :).
>
I thought the odd/even numbering used to 2.5.xx was fine, and I think having the 
numbering reflect feature set (as it more or less does now) is better than any 
scheme based on date.

That said, this topic will be decided by the vote of the electorate, from a 
voter pool of one (Linus). Unless he has changed his mind this is all moot anyway.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

