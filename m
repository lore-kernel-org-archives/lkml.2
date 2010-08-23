Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0HWSp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:45:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35223 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0HWSpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:45:24 -0400
Message-ID: <4C72C1B9.1010503@zytor.com>
Date: Mon, 23 Aug 2010 11:45:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Mark Stanovich <mrktimber@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.3
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com> <4C6F4BBB.5040207@zytor.com> <4C72B82C.7060707@msgid.tls.msk.ru>
In-Reply-To: <4C72B82C.7060707@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 11:04 AM, Michael Tokarev wrote:
> 21.08.2010 07:44, H. Peter Anvin wrote:
>> On 08/20/2010 08:40 PM, Mark Stanovich wrote:
>>> After updating to the 2.6.35.3 stable release, my machine was rebooting
>>> automatically during the first few seconds of boot.
>>>
>>> I bisected to the first bad commit of
>>>
>>> commit 568132624386f53e87575195d868db
>>> 9afb2e9316
>>> Author: H. Peter Anvin <hpa@zytor.com <mailto:hpa@zytor.com>>
>>> Date:   Tue Jul 27 17:01:49 2010 -0700
>>>
>>>     x86: Add memory modify constraints to xchg() and cmpxchg()
> 
> This commit also present in 2.6.32.stable (since 2.6.32.19).
> Should it be fixed there as well?
> 

Yes, in particular 69309a05907546fb686b251d4ab041c26afe1e1d should be
applied to all instances of this commit.

As far as we can tell it's a gcc bug, but it hasn't been thoroughly
root-caused to that yet.

	-hpa
