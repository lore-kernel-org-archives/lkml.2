Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0DPO1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:27:01 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:34792 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0DPO1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:27:00 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: samu.p.onkalo@nokia.com, jkosina@suse.cz, akpm@linux-foundation.org,
       pavel@ucw.cz, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input
 interface
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz>
 <4BBF2BD1.5050107@tremplin-utc.net>
 <alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz>
 <op.va86rulwgp7y00@linux-r26l.site>
 <62697B07E9803846BC582181BD6FB6B826A8525E8A@NOK-EUMSG-02.mgdnok.nokia.com>
 <op.va878jw6gp7y00@linux-r26l.site> <4BC86C9B.4010400@tremplin-utc.net>
Date: Fri, 16 Apr 2010 16:26:52 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Marcin Derlukiewicz" <marcin@derlukiewicz.pl>
Message-ID: <op.va9ee2z6gp7y00@linux-r26l.site>
In-Reply-To: <4BC86C9B.4010400@tremplin-utc.net>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 16-04-2010 o 15:56:43 Éric Piel <eric.piel@tremplin-utc.net>  
napisał(a):

> On 16/04/10 14:13, Marcin Derlukiewicz wrote:
>> Dnia 16-04-2010 o 14:00:15 <samu.p.onkalo@nokia.com> napisał(a):
>>
> :
>>>
>>> Could you check what is the polling period of the device.
>>> something like:
>>> cat /sys/devices/platform/lis3lv02d/input/input9/poll
>>>
>>> it is current polling period in milliseconds. 0 disables polling.
>>>
>>> -Samu
>>>
>>
>> I think that on my system this is /sys/devices/platform/lis3lv02d/rate
>> but i may be wrong. Anyway it contains 40 as a number.
> This file is something else. Isn't there any file like
> /sys/devices/platform/lis3lv02d/input/input*/poll ?
>
> Maybe your kernel is too old to have this functionality (I don't know
> when it was introduced). Samu is right, here to disable the joystick, I
> can indeed do a:
> echo 0 > /sys/devices/platform/lis3lv02d/input/input*/poll
>
> Eric

nope, should i paste you list?
my kernel is 2.6.31.12
