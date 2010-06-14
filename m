Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0FNTEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:04:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60811 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0FNTEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:04:35 -0400
MIME-Version: 1.0
X-Originating-IP: [98.247.59.227]
In-Reply-To: <AANLkTik-xhwWwE0YXgkeETPtZZH5ze-_wt-9gOy2fBoq@mail.gmail.com>
References: <AANLkTilZkfvBiwliJ6JKXfvS0V3cvO_AAIj6quegvYgq@mail.gmail.com>
	<AANLkTik-xhwWwE0YXgkeETPtZZH5ze-_wt-9gOy2fBoq@mail.gmail.com>
Date: Mon, 14 Jun 2010 12:04:34 -0700
Message-ID: <AANLkTikRYRsp6pTSUk3ret2ZV9m8ByqEWcEcUMOHXcSa@mail.gmail.com>
Subject: Re: Testing to see if a driver is loaded
From: Robert Emanuele <rob@emanuele.us>
To: Raj singh <linux.rajsingh@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raj,

I appreciate the thought, but if you read my email closely you'll see
that I was looking for how to find if a driver is loaded into the
kernel (module or not) from within another driver's probe function.

--Rob

On Sun, Jun 13, 2010 at 11:48 PM, Raj singh <linux.rajsingh@gmail.com> wrote:
> Hi ,
>         You can use lsmod command...
>
> login as root & type lsmod | head -10...it will show you a list of drivers
> currently loaded in your kernel....
>
>
> Raj.
>
> On Sun, Jun 13, 2010 at 10:03 AM, Robert Emanuele <rob@emanuele.us> wrote:
>>
>> Greetings once again,
>>
>> I was wondering if there is a simple way to test if a driver is loaded
>> from within another driver's probe?  I have one driver that depends on
>> another.  I see several *_find_device functions in
>> include/linux/device.h.  I haven't found a "find driver" nor an
>> arbitrary way of doing that.
>>
>> Thanks for any guidance,
>>
>> Rob
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
