Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab0KKJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:26:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44606 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0KKJ0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:26:23 -0500
MIME-Version: 1.0
X-Originating-IP: [192.55.46.36]
In-Reply-To: <AANLkTinj_Ft-nxqSQ=3JA_7oxSrLk4HSuXA6Y2oyjYNh@mail.gmail.com>
References: <20101110192053.GA6978@lenovo>
	<AANLkTin=X_cc0ZpohWWOynhXGBv5Mw-9DcSjFWtRskKB@mail.gmail.com>
	<AANLkTinj_Ft-nxqSQ=3JA_7oxSrLk4HSuXA6Y2oyjYNh@mail.gmail.com>
Date: Thu, 11 Nov 2010 17:26:21 +0800
Message-ID: <AANLkTinicErGvOdh4Y_-X2OBm38WzdUcWxjuz3gztBt-@mail.gmail.com>
Subject: Re: [RFC -tip] x86, apic: Merge x2apic code
From: Lin Ming <lin@ming.vg>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 4:38 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 11/11/10, Lin Ming <lin@ming.vg> wrote:
>> On Thu, Nov 11, 2010 at 3:20 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>  Hi, while being at x2apic_x.c code I noted that files look similar to
>>> each other so I guessed may be we could merge them. As result --
>>> this patch.
>>>
>>>  Note that patch was only _compile_ tested, I don't have such apic for
>>> real. I've trying to make it carefully but more reviews are needed,
>>> I definitely might miss something.
>>
>> Hi, Cyrill
>>
>> I just give it a try on Nehalem-EX machine with x2apic.
>> It boots fine.
>>
>> Lin Ming
>>
> hi Ming, thanks a huge! could you please give a try to physical mode
> as well, ie with x2apic_phys boot param (if you have time of course.
> :)
>

No problem.
I'll test it tomorrow when I back to office.
