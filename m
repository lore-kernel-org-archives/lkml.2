Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab0KQE3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:29:39 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50017 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768Ab0KQE3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:29:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R5prQWUS6KP05H5brZ2+AIDrolkk9CZgCS2YCmGb1FWdi2Vi4Mn+uMwL+4+QBDUNlq
         N7AxU0Q2Xx2rlrr0BGllJMVglBVqSRw0cOnUQNH0rWi19I0zZWrIxCXKu9WyOV706Est
         PZqyuJn58fIn0NkkPM0Yaza4hBthnKUEv0dVc=
MIME-Version: 1.0
In-Reply-To: <4CE340BC.1010701@leadcoretech.com>
References: <20101109123246.GA11477@amd>
	<20101114182614.BEE5.A69D9226@jp.fujitsu.com>
	<20101115092452.BEF1.A69D9226@jp.fujitsu.com>
	<20101116074717.GB3460@amd>
	<AANLkTi=BhuVn8F3ioTyR8S=J3LfJbuhYsMoHf9f=bvRn@mail.gmail.com>
	<4CE23B3B.5050804@leadcoretech.com>
	<AANLkTi=10NspL2fw66De8osjUC+2xnxsLpw+x=oNQQTv@mail.gmail.com>
	<4CE23F33.5060401@leadcoretech.com>
	<AANLkTi=Da76M+s92ZZnfw7ySjp3WWfDjW6n5G=hHheKB@mail.gmail.com>
	<4CE340BC.1010701@leadcoretech.com>
Date: Wed, 17 Nov 2010 06:29:36 +0200
Message-ID: <AANLkTi==W_KHL3pd8Cq=ojV=aAAOxi4c=ZkHSednOVyH@mail.gmail.com>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
From: Anca Emanuel <anca.emanuel@gmail.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/17 Figo.zhang <zhangtianfei@leadcoretech.com>:
> 于 11/16/2010 04:26 PM, Anca Emanuel 写道:
>> On Tue, Nov 16, 2010 at 10:22 AM, Figo.zhang
>> <zhangtianfei@leadcoretech.com>  wrote:
>>> 于 11/16/2010 04:20 PM, Anca Emanuel 写道:
>>>>
>>>> On Tue, Nov 16, 2010 at 10:05 AM, Figo.zhang
>>>> <zhangtianfei@leadcoretech.com>   wrote:
>>>>>
>>>>> 于 11/16/2010 03:53 PM, Anca Emanuel 写道:
>>>>>>
>>>>>> Nick, I want to test your tree.
>>>>>> This is taking too long.
>>>>>> Make something available now. And test it in real configs.
>>>>>>
>>>>>
>>>>> hi Anca,
>>>>>
>>>>> would you like to give your test method?
>>>>>
>>>>
>>>> Nothig special, for now I will test on my PC.
>>>>
>>>
>>> hi KOSAKI Motohiro,
>>>
>>> is it any test suite or test scripts for test page-reclaim performance?
>>>
>>> Best,
>>> Figo.zhang
>>>
>>
>> There is http://www.phoronix.com
>
> it is not focus on page-reclaim test, or specially for MM.
>>
>
>

If you want some special test, you have to ask Michael Larabel for that.
http://www.phoronix-test-suite.com/
