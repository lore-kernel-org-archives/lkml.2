Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab0E0Ozk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:55:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54757 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504Ab0E0Ozh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:55:37 -0400
X-Sasl-enc: yvJXId4nunzmCtYgT5H3UEmiRp+V+4J6jJ9daZPrXMXb 1274972136
Message-ID: <4BFE87E6.7080701@ladisch.de>
Date: Thu, 27 May 2010 16:55:34 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Jan Engelhardt <jengelh@medozas.de>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: No mixers on ATI RS780 Azalia
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr>	<s5hmxvmzwwd.wl%tiwai@suse.de>	<alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr>	<4BFD2901.20800@ladisch.de>	<alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr>	<4BFE5AA1.7070103@ladisch.de> <alpine.LSU.2.01.1005271420320.29122@obet.zrqbmnf.qr> <4BFE8404.2000005@gmail.com>
In-Reply-To: <4BFE8404.2000005@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> On 05/27/2010 06:34 AM, Jan Engelhardt wrote:
>> On Thursday 2010-05-27 13:42, Clemens Ladisch wrote:
>>> It is possible that an embedded device like this requires some custom
>>> initialization.  Can you find out if the Windows driver is the standard
>>> Microsoft driver or Samsung's?
>>
>> Looks like the Microsoft one:
> 
> Well, not Samsung, but it's not the Microsoft HDA driver either, it's 
> using a Realtek driver.
> 
>> == "ATI HDMI Audio" ==
>> ...
>> C:\WINDOWS\system32\drivers\RtHDMI.sys
>> 	Realtek, 5.10.0.5602 built by WinDDK

Googling shows that this is the driver that AMD ships for its "ATI HDMI"
devices.

>> == "Realtek High Definition Audio" ==
>> ...

This also looks like the standard driver.


Apparently, this computer uses standard audio hardware; the culprit is
probably the Linux radeon driver.


Regards,
Clemens
