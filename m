Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab0DPN4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 09:56:51 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:50694 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693Ab0DPN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 09:56:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4BC86C9B.4010400@tremplin-utc.net>
Date: Fri, 16 Apr 2010 15:56:43 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcin Derlukiewicz <marcin@derlukiewicz.pl>
CC: samu.p.onkalo@nokia.com, jkosina@suse.cz, akpm@linux-foundation.org,
       pavel@ucw.cz, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input interface
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz> <4BBF2BD1.5050107@tremplin-utc.net> <alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz> <op.va86rulwgp7y00@linux-r26l.site> <62697B07E9803846BC582181BD6FB6B826A8525E8A@NOK-EUMSG-02.mgdnok.nokia.com> <op.va878jw6gp7y00@linux-r26l.site>
In-Reply-To: <op.va878jw6gp7y00@linux-r26l.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/10 14:13, Marcin Derlukiewicz wrote:
> Dnia 16-04-2010 o 14:00:15 <samu.p.onkalo@nokia.com> napisał(a):
> 
:
>>
>> Could you check what is the polling period of the device.
>> something like:
>> cat /sys/devices/platform/lis3lv02d/input/input9/poll
>>
>> it is current polling period in milliseconds. 0 disables polling.
>>
>> -Samu
>>
> 
> I think that on my system this is /sys/devices/platform/lis3lv02d/rate
> but i may be wrong. Anyway it contains 40 as a number.
This file is something else. Isn't there any file like
/sys/devices/platform/lis3lv02d/input/input*/poll ?

Maybe your kernel is too old to have this functionality (I don't know
when it was introduced). Samu is right, here to disable the joystick, I
can indeed do a:
echo 0 > /sys/devices/platform/lis3lv02d/input/input*/poll

Eric
