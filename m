Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab0HWSLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:11:46 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:34143 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab0HWSLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:11:44 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 14:11:43 EDT
Message-ID: <4C72B82C.7060707@msgid.tls.msk.ru>
Date: Mon, 23 Aug 2010 22:04:28 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mark Stanovich <mrktimber@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.3
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com> <4C6F4BBB.5040207@zytor.com>
In-Reply-To: <4C6F4BBB.5040207@zytor.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21.08.2010 07:44, H. Peter Anvin wrote:
> On 08/20/2010 08:40 PM, Mark Stanovich wrote:
>> After updating to the 2.6.35.3 stable release, my machine was rebooting
>> automatically during the first few seconds of boot.
>>
>> I bisected to the first bad commit of
>>
>> commit 568132624386f53e87575195d868db
>> 9afb2e9316
>> Author: H. Peter Anvin <hpa@zytor.com <mailto:hpa@zytor.com>>
>> Date:   Tue Jul 27 17:01:49 2010 -0700
>>
>>     x86: Add memory modify constraints to xchg() and cmpxchg()

This commit also present in 2.6.32.stable (since 2.6.32.19).
Should it be fixed there as well?

Thanks!

/mjt
