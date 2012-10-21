Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2JUVYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 17:24:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55434 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2JUVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 17:24:04 -0400
Message-ID: <508467EE.4040807@ti.com>
Date: Sun, 21 Oct 2012 14:23:58 -0700
From: Tom Rini <trini@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur> <d556fc0f-da5d-4531-b331-6dc086461f34@blur> <50833F30.4020802@ti.com> <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com> <20121021041858.GA14809@jshin-Toonie> <50843627.4020103@ti.com> <20121021210633.GA14311@jshin-Toonie>
In-Reply-To: <20121021210633.GA14311@jshin-Toonie>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/12 14:06, Jacob Shin wrote:
> On Sun, Oct 21, 2012 at 10:51:35AM -0700, Tom Rini wrote:
>> On 10/20/12 21:18, Jacob Shin wrote:
>>> On Sat, Oct 20, 2012 at 09:01:43PM -0700, Yinghai Lu wrote:
>>>> On Sat, Oct 20, 2012 at 5:17 PM, Tom Rini <trini@ti.com> wrote:
>>>>> On 10/20/12 17:11, Shin, Jacob wrote:
>>>>>> Hi could you please attach the dmesg output? Before rc2 is fine as well.
>>>>>> I would like to see the E820 table. Thank you,
>>>>>
>>>>> dmesg is quite long so I've put it on pastebin: http://pastebin.com/4eSPEAvB
>>>>>
>>>>> --
>>>>
>>>> [    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000042fffffff] usable
>>>>
>>>> pre-calculate table size is too small, so it crashes.
>>>
>>> Right,
>>>
>>> I think just this one patch 3/6 on top of -rc2 should work:
>>>
>>> https://lkml.org/lkml/2012/8/29/223
>>>
>>> That would be a simpler path for 3.7,
>>
>> It doesn't apply easily (for me) on top of 3.7-rc2 however.  Happy to
>> test a patch on top of 3.7-rc2 when you're able to.
> 
> Ah, sorry, this one should apply on top of 3.7-rc2:
> 
> https://lkml.org/lkml/2012/8/24/469
> 
> Could you try that? Just that single patch, not the whole patchset.

That fixes it, replied with a note and Tested-by, thanks!

-- 
Tom

