Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2AYMLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:11:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34698 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab2AYMLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:11:48 -0500
MIME-Version: 1.0
In-Reply-To: <4F1FD2AA.9020708@broadcom.com>
References: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
	<4F1FBAA9.4040405@broadcom.com>
	<CAC9WiBjpsLuJhzw+vZsPC2bA73mad444Gq32DRL_gCri2MqaMw@mail.gmail.com>
	<4F1FD2AA.9020708@broadcom.com>
Date: Wed, 25 Jan 2012 07:11:46 -0500
Message-ID: <CA+5PVA73WHfnurWiyY4w9f4_mw=vUdpaNmAavHZtt+xYfo8Kcw@mail.gmail.com>
Subject: Re: kernel 3.2.1: BUG: scheduling while atomic: swapper/0/0/0x10000100
From: Josh Boyer <jwboyer@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 5:00 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 01/25/2012 09:35 AM, Francis Moreau wrote:
>> Hi Arend,
>>
>> On Wed, Jan 25, 2012 at 9:17 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 01/24/2012 04:59 PM, Francis Moreau wrote:
>>>> Hi,
>>>>
>>>> Just in case someone is interested, I've been hit by this:
>>>>
>>>> [  236.734640] BUG: scheduling while atomic: swapper/0/0/0x10000100
>>>
>>> I hit that problem yesterday as well on 3.3.0-rc1. I suspected it came
>>> from my development changes on brcmfmac, but you are not using that.
>>
>> I'm not sure it's related to the brcmfmac, because the RFKILL switch
>> was off when it happened.
>>
>> Were you writting/reading from/to a SD card by any chances when it did trigger ?
>>
>
> Nope. It was a USB device driver. Maybe it was conincidental that it
> happened shortly after loading the driver, but I tend to mistrust my own
> stuff ;-). I posted a question in my issue yesterday (see [1]).

We've had a few similar issues reported in Fedora yesterday after we
rebased to 3.2.1.
I've not found a common trend yet, but there is definitely an issue on
some hardware in
3.2.1

josh
