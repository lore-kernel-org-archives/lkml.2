Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1JMUG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab1JMUGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:06:55 -0400
Message-ID: <4E9744C1.5040903@redhat.com>
Date: Thu, 13 Oct 2011 17:06:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= <niso@kth.se>
CC: Borislav Petkov <bp@amd64.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i7core_edac: fix erroneous size of static array
References: <1318530294-6829-1-git-send-email-niso@kth.se> <20111013185656.GC3064@aftab> <4E97442A.80308@kth.se>
In-Reply-To: <4E97442A.80308@kth.se>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-10-2011 17:03, Niklas Söderlund escreveu:
> On 10/13/2011 08:56 PM, Borislav Petkov wrote:
> 
>> On Thu, Oct 13, 2011 at 02:24:54PM -0400, Niklas Söderlund wrote:
>>> Signed-off-by: Niklas Söderlund <niso@kth.se>
>>> ---
>>>  drivers/edac/i7core_edac.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
>>> index 70ad892..e0f6096 100644
>>> --- a/drivers/edac/i7core_edac.c
>>> +++ b/drivers/edac/i7core_edac.c
>>> @@ -441,7 +441,7 @@ static inline int numrow(u32 row)
>>>  
>>>  static inline int numcol(u32 col)
>>>  {
>>> -	static int cols[8] = {
>>> +	static int cols[4] = {
>>>  		1 << 10, 1 << 11, 1 << 12, -EINVAL,
>>>  	};
>>
>> Even better,
>>
>> you could completely remove the number in the [] since the {}
>> initializer contains all array elements already. In this and the
>> remaining arrays in those small inline functions.
>>
> 
> 
> Thanks for the feedback!
> 
> What would be the correct way of submitting an updated patch? Sending it
> in this mail thread or create a new one?

[PATCHv2] is the usual way. if you're using git, you may use the msgid of
the first message as a reference for the version 2.

Mauro.
