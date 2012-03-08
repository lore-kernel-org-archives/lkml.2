Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2CHInc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:43:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44742 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2CHInb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 03:43:31 -0500
MIME-Version: 1.0
In-Reply-To: <4F586266.8060504@linux.intel.com>
References: <1329393691.6830.20.camel@jonspc>
	<1329512682.29051.1.camel@jonspc>
	<1329570128.6670.0.camel@jonspc>
	<4F400BBF.9020707@ladisch.de>
	<1329603022.1089.57.camel@jonspc>
	<4F41FC28.1070605@ladisch.de>
	<1329926198.22918.10.camel@jonspc>
	<4F45167A.6080706@ladisch.de>
	<1330043397.4669.44.camel@jonspc>
	<CAMiH66EdB9KN1gw_hG=34zab56RxcPKB7G2MyJALfD_5z1yeVQ@mail.gmail.com>
	<4F57C007.5050006@linux.intel.com>
	<CAMiH66E3z3H2cYQs5KQuVp_iNdusOYJ+XF6jfbJ9Z_uJ7v45_w@mail.gmail.com>
	<4F582949.6000708@linux.intel.com>
	<CAMiH66HQ=K9ucKeHP_AuXY9COd083AvsT+Nu-L2=WS-bu35rkQ@mail.gmail.com>
	<4F586266.8060504@linux.intel.com>
Date: Thu, 8 Mar 2012 16:43:30 +0800
Message-ID: <CAMiH66HUKgPA5LAT_WsWZR6R0qfn6Q0aAOi6iYMEFonODMvPxQ@mail.gmail.com>
Subject: Re: Random process lockup on ARM board: alsa-lib-1.0.25, FUTEX_WAIT_PRIVATE
From: Huang Shijie <shijie8@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: jon@jonshouse.co.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 3:40 PM, Darren Hart <dvhart@linux.intel.com> wrote:
>
>
> On 03/07/2012 08:24 PM, Huang Shijie wrote:
>> hi,
>>
>> On Thu, Mar 8, 2012 at 11:36 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>>>
>>>
>>> On 03/07/2012 06:28 PM, Huang Shijie wrote:
>>>> Hi,
>>>>
>>>> On Thu, Mar 8, 2012 at 4:07 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>>>>>
>>>>>
>>>>> On 02/29/2012 01:12 AM, Huang Shijie wrote:
>>>>>> Hi ,
>>>>>>
>>>>>> I meet a similar problem with the latest futex code.
>>>>>>
>>>>>> I play the video and the processes will hang at the futex.
>>>>>
>>>>> Are either of you able to bisect the kernel? At the very least can you
>>>>
>>>> I finially found my arch/arm/include/asm/futex.h is not the
>>>> latest, so i updated the header.
>>>
>>> Just make sure it matches your kernel version.
>>>
>>>>
>>>> And the futex issue is gone now. But a dataAbort issue appears, I am
>>>> not sure whether it caused by the futex patch.
>>>> I am debugging it now.
>>>
>>> Which APIs are you using that make the futex syscall?
>>>
>>
>> futex_wait().
>
> You are calling the futex syscall directly from your application?
>

The application call futex(), but i ever hung at futex_wait().

Huang Shijie
