Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2CTGEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 02:04:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54183 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2CTGEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 02:04:33 -0400
Message-ID: <4F681DEE.9030903@gmail.com>
Date: Mon, 19 Mar 2012 23:04:30 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: INFO: suspicious RCU usage. on 3.3.0-rc7-next-20120316
References: <4F6600FA.7050005@gmail.com> <20120318155401.GA8045@dhcp-172-17-108-109.mtv.corp.google.com> <4F661E89.5050000@gmail.com> <20120319170122.GG11069@google.com>
In-Reply-To: <20120319170122.GG11069@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 10:01 AM, Tejun Heo wrote:
> On Sun, Mar 18, 2012 at 10:42:33AM -0700, Justin P. Mattock wrote:
>>> Known problem.  The following pending patchset should fix the problem.
>>>
>>>    http://thread.gmane.org/gmane.linux.kernel/1263989
>>>
>>> Jens?
>>>
>>> Thakns.
>>>
>>
>> cool thanks for the info..
>> I went and applied your patches(all 5) and there is fuzz, and some
>> errors with linux-next.
>> seems the suspicious message is still there, but the system boots up
>> just fine with the patches in.
>>   maybe manually applying them by hand is what I need to do for -next
>> so I dont miss anything important with the patch that takes care of
>> the suspicious message.
>
> Hmm... weird.  I just double check and the patch series makes the
> warning go away.  Can you please try the following git branch instead?
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-stats
>
> Thanks.
>


alright! I built and ran misc.git. I am not seeing this warning, if its 
safe to say this fixes the warning then its cool, but if not then I can 
try this patch on linux-next just to see.. other than that Thanks for 
the info/help!

Justin P. Mattock
