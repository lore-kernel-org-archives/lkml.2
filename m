Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302Ab0HGAp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:45:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49371 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0HGApz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:45:55 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Simon Horman <horms@verge.net.au>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] MAINTAINERS: kexec-tools has moved
References: <20100729041641.GA32220@verge.net.au>
	<20100806233203.GA10040@verge.net.au> <4C5C9BC2.8020502@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Aug 2010 17:45:50 -0700
In-Reply-To: <4C5C9BC2.8020502@zytor.com> (H. Peter Anvin's message of "Fri\, 06 Aug 2010 16\:33\:22 -0700")
Message-ID: <m1sk2rtflt.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 08/06/2010 04:32 PM, Simon Horman wrote:
>> On Thu, Jul 29, 2010 at 01:16:41PM +0900, Simon Horman wrote:
>>> Kexec tools has been moved to http://kernel.org/pub/linux/utils/kernel/kexec/
>>> as user-space code shouldn't be in /pub/linux/kernel
>>>
>>> Signed-off-by: Simon Horman <horms@verge.net.au>
>> 
>> Eric, ping.
>> 
>> What is your preferred path for this change to get merged?
>> 
>>>
>>> Index: linux-2.6/MAINTAINERS
>>> ===================================================================
>>> --- linux-2.6.orig/MAINTAINERS	2010-07-29 13:10:04.000000000 +0900
>>> +++ linux-2.6/MAINTAINERS	2010-07-29 13:11:40.000000000 +0900
>>> @@ -3334,7 +3334,7 @@ F:	drivers/s390/kvm/
>>>  
>>>  KEXEC
>>>  M:	Eric Biederman <ebiederm@xmission.com>
>>> -W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
>>> +W:	http://kernel.org/pub/linux/utils/kernel/kexec/
>>>  L:	kexec@lists.infradead.org
>>>  S:	Maintained
>>>  F:	include/linux/kexec.h
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Eric is on vacation this week, AFAIK.

I am on vacation..  However having made the mistake of checking my email.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I guess I don't have a particular favorite path for something to make
it to MAINTAINERS.  But since we have move the location of the the
userspace repository merging this somehow seems like a good idea.

As I am on vacation I'm not motivated to push this to Linus, or much
of anywhere else, which sucks because the merge window is open right
now.  I think historically patches like this have gone through Andrew.

Eric
