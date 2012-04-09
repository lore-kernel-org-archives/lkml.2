Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2DIGw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:52:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47233 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2DIGw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:52:57 -0400
MIME-Version: 1.0
In-Reply-To: <4F7F52BD.7060906@candelatech.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
Date: Mon, 9 Apr 2012 12:22:56 +0530
Message-ID: <CAD2nsn0ji7Vxa=hCiZ+Ujw3SzJjHy_FfCzMOjcPOi5eXRBLT+w@mail.gmail.com>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Michael Leun <lkml20120218@newton.leun.net>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Sat, Apr 7, 2012 at 2:01 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 04/05/2012 10:11 PM, Mohammed Shafi wrote:
>>
>> Hi Ben,
>>
>> On Thu, Apr 5, 2012 at 11:55 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> I see the regression on my WPEA-127N systems as well.
>>>
>>> With the patch applied to 3.3.1, I see never ending stream of
>>> auth timeouts (this log is watching 'iw event' output)
>>>
>>> power-management is OFF on my system, and using nohwcrypt,
>>> in case that matters.
>
>
>> i think its best for me try to download the 3.3.1 stable kernel and
>> see if this issue happens,
>> i am going to start it now, Ben does this happens with  latest
>> wireless testing tree?
>> its quite weird 3.4-rc1 works as some user reported and while 3.3.1 does
>> not.
>> i will try to come with some suggestion patches
>
>
> I have not tried wireless-testing lately...sort of been waiting for
> it to sync with upstream and become active again before going to the
> effort.

ah yes, i am now compiling 3.4-rc2 and trying it out.

>
> But, I'll try it out soon if you have no luck reproducing the
> problem on 3.3.1.

ok, thanks. i may need your help if it does not shows up 3.4-rc2.
while i am doing code analysis
and giving some test patches. thank you!

>
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>



-- 
thanks,
shafi
