Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0LHIMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:12:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38210 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0LHIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:12:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CFF3DA4.5060705@jp.fujitsu.com>
Date: Wed, 08 Dec 2010 17:11:16 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "jmarchan@redhat.com" <jmarchan@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com> <4CFDDFC3.2070107@jp.fujitsu.com> <4CFF34E7.2030401@fusionio.com> <4CFF3AD6.6010904@jp.fujitsu.com> <4CFF3C86.2070504@fusionio.com>
In-Reply-To: <4CFF3C86.2070504@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

(2010/12/08 17:06), Jens Axboe wrote:
>>>> I hit on another approach. Although it doesn'tprevent any merge as Linus
>>>> preferred, it can fix the problem anyway. In this idea, in_flight is
>>>> incremented and decremented for the partition which the request belonged
>>>> to in its creation. It has the following merits.
>>
>> Revert is already finished. 2.6.37-rc-5 and latest stable kernel doesn't
>> contain Yasuaki's former logic.
>>
>> https://lkml.org/lkml/2010/10/24/118
>
> Yes I know, that is why I said:
>
>>> I really would prefer if we fixed up the patchset we ended up reverting.
>>> At least that had a purpose with growing struct request, since we saved
>>> on doing the partition lookups.
>
> That I prefer we fix that code up, since I think it's the best solution
> to the problem.
>

I already postedit.

https://lkml.org/lkml/2010/12/8/12

I think it is OK without mail subject :-)

Thanks,
Satoru

