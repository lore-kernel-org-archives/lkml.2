Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1ETMvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:51:06 -0400
Received: from lucidpixels.com ([75.144.35.66]:57987 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1ETMvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:51:05 -0400
Date: Fri, 20 May 2011 08:51:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.LFD.2.02.1105201445300.3078@ionos>
Message-ID: <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 May 2011, Thomas Gleixner wrote:

> On Fri, 20 May 2011, Justin Piszcz wrote:
>
>> Hi,
>>
>> I tried this in 2.6.39 and experienced crashes for the first time, when
>> using: threadirqs
>>
>> user     pts/1                         Fri May 20 04:31   still logged in
>> reboot   system boot  2.6.39           Fri May 20 04:28 - 04:36  (00:07) user
>> pts/2                         Thu May 19 20:01 - down   (08:24) reboot
>> system boot  2.6.39           Thu May 19 20:01 - 04:26  (08:25) user
>> pts/28                        Thu May 19 15:57 - crash  (04:03)
>>
>> Not sure I can give any useful output as there is nothing in the logs, even
>> with netconsole enabled, no useful output was produced.
>
> Hmm. Machine lacks serial console, right? Can you send me your .config
> please?
>
> Thanks,
>
> 	tglx
>

Hi,

Correct, no serial port or header, config:
http://home.comcast.net/~jpiszcz/20110520/config-2.6.39-3.txt

Justin.

