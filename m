Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2G3AQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 20:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab2G3AQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 20:16:38 -0400
Message-ID: <5015D25E.9070308@redhat.com>
Date: Sun, 29 Jul 2012 21:16:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: fix DOCBOOKS=... building
References: <1339577020.4519.19.camel@jlt3.sipsolutions.net>	 <5013162C.9030606@xenotime.net> <1343474795.4980.4.camel@jlt3.sipsolutions.net> <5013FFD4.80501@xenotime.net> <501484C3.2090808@landley.net>
In-Reply-To: <501484C3.2090808@landley.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-07-2012 21:33, Rob Landley escreveu:
> On 07/28/2012 10:05 AM, Randy Dunlap wrote:
>> On 07/28/2012 04:26 AM, Johannes Berg wrote:
>>
>>> On Fri, 2012-07-27 at 15:29 -0700, Randy Dunlap wrote:
>>>> On 06/13/2012 01:43 AM, Johannes Berg wrote:
>>>>
>>>>> From: Johannes Berg <johannes.berg@intel.com>
>>>>>
>>>>> Prior to
>>>>> commit 4266129964b8238526936d723de65b419d8069c6
>>>>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>> Date:   Tue May 31 16:27:44 2011 -0300
>>>>>
>>>>>      [media] DocBook: Move all media docbook stuff into its own directory
>>>>>
>>>>> it was possible to build only a single (or more)
>>>>> book(s) by calling, for example
>>>>> 	make htmldocs DOCBOOKS=80211.xml
>>>>>
>>>>> This now fails:
>>>>> cp: target `.../Documentation/DocBook//media_api' is not a directory
>>>>>
>>>>> Ignore errors from that copy to make this possible again.
>>>>>
>>>>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>>>> ---
>>>>> I complained about this a long time ago, but now it finally bothered me
>>>>> enough to fix it ... :-)
>>>>
>>>>
>>>> Thanks.
>>>>
>>>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>>>
>>> Can you apply it somewhere, or should I send it to Andrew, or do you
>>> have any other ideas?
>>
>>
>> I'm no longer the Documentation maintainer, but Rob Landley
>> could merge it.  You probably will need to resend it to him.

Sorry for not answering earlier. I was on vacations ;)

> 
> Acked-by: Rob landley <rob@landley.net>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> 
> I'll forward it. Thanks,
> 
> Rob
> 

Regards,
Mauro

