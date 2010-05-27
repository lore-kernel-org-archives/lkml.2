Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0E0Bbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 21:31:53 -0400
Received: from crca.org.au ([74.207.252.120]:53545 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0E0Bbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 21:31:52 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BFDCB82.6030908@crca.org.au>
Date: Thu, 27 May 2010 11:31:46 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [PATCH 0/5] Preallocate swap + minor fix.
References: <4BFCC939.1000901@crca.org.au> <201005262321.09971.rjw@sisk.pl>
In-Reply-To: <201005262321.09971.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 27/05/10 07:21, Rafael J. Wysocki wrote:
> On Wednesday 26 May 2010, Nigel Cunningham wrote:
>> Hi all.
>>
>> In current in-kernel hibernation code, swap is allocated as the image is
>> being written.
>>
>> The first four patches in this series rework things so that all swap
>> that will be used is allocated prior to any data being written to disk.
>> The fourth patch might look like too much for one patch, but it's
>> necessary to not break bisecting.
>>
>> The fifth patch fixes a minor error in displaying the speed at which I/O
>> occurred.
>>
>> This is the beginning of what I hope will be a long series of sets of
>> patches, first working towards adding support for properly asynchronous
>> I/O (not batching, as is currently done), then compression, multiple
>> swap devices and more. In short, this is the beginning of work on
>> merging TuxOnIce functionality a bit at a time.
>>
>> The work is coming now because I recently finished my previous job, so
>> I'm seeking to get some of those jobs I've been wanting to do for a long
>> time out of the way. If anyone wants to employ me to do this work, I
>> wouldn't say no! :)
>>
>> Please excuse me if there are wrapping issues with the patches - I'm
>> using Thunderbird, and haven't sent a patch series for quite a while, so
>> don't remember the fancy git mailer way (will have to look it up).
>>
>> Rafael, these and future patches will be available at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/nigelc/tuxonice-head.git#for-rafael
>
> Thanks for the patches, I'll have a look at them as soon as I can.

Thank you! I've got other stuff to work on today, but hope to prepare 
another set of patches tomorrow.

> I haven't replied to your hibernation algorithm idea, mostly because I didn't
> have the time to look into it more thoroughly and I don't remember all of the
> details.  I'm still going to reply to it, though.

Thanks.

Nigel
