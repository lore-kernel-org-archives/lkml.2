Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0LHIGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:06:40 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:49214 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab0LHIGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:06:39 -0500
X-ASG-Debug-ID: 1291795597-085395430001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CFF3C86.2070504@fusionio.com>
Date: Wed, 8 Dec 2010 16:06:30 +0800
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "jmarchan@redhat.com" <jmarchan@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com> <4CFDDFC3.2070107@jp.fujitsu.com> <4CFF34E7.2030401@fusionio.com> <4CFF3AD6.6010904@jp.fujitsu.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] Don't merge different partition's IOs
In-Reply-To: <4CFF3AD6.6010904@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1291795597
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.41
X-Barracuda-Spam-Status: No, SCORE=0.41 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.48809
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-08 15:59, Satoru Takeuchi wrote:
> Hi Jens,
> 
> (2010/12/08 16:33), Jens Axboe wrote:
>> On 2010-12-07 15:18, Satoru Takeuchi wrote:
> 
>>> I hit on another approach. Although it doesn'tprevent any merge as Linus
>>> preferred, it can fix the problem anyway. In this idea, in_flight is
>>> incremented and decremented for the partition which the request belonged
>>> to in its creation. It has the following merits.
> 
> Revert is already finished. 2.6.37-rc-5 and latest stable kernel doesn't
> contain Yasuaki's former logic.
> 
> https://lkml.org/lkml/2010/10/24/118

Yes I know, that is why I said:

>> I really would prefer if we fixed up the patchset we ended up reverting.
>> At least that had a purpose with growing struct request, since we saved
>> on doing the partition lookups.

That I prefer we fix that code up, since I think it's the best solution
to the problem.

-- 
Jens Axboe

