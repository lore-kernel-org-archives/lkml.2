Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab0J1Kog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:44:36 -0400
Received: from mailout1.go2.pl ([193.17.41.11]:32861 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0J1Kod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:44:33 -0400
Message-ID: <4CC95406.4070103@o2.pl>
Date: Thu, 28 Oct 2010 12:44:22 +0200
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101024 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [SERIAL]blacklist si3052 chip
References: <4CC73085.2070304@o2.pl> <20101026224940.22b4ac93@lxorguk.ukuu.org.uk> <4CC74E04.7080407@o2.pl> <20101028012010.GC29960@kroah.com>
In-Reply-To: <20101028012010.GC29960@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 63
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 28.10.2010 03:20, Greg KH pisze:
> On Tue, Oct 26, 2010 at 11:54:12PM +0200, Maciej Szmigiero wrote:
>> W dniu 26.10.2010 23:49, Alan Cox pisze:
>>> On Tue, 26 Oct 2010 21:48:21 +0200
>>> Maciej Szmigiero <mhej@o2.pl> wrote:
>>>
>>>> [SERIAL]blacklist si3052 chip
>>>>
>>>> Si3052-based softmodems aren't serial ports so don't bind serial driver to them.
>>>> Allows proper driver to bind to them.
>>>
>>> Which is the proper driver ?
>>>
>>> Alan
>>>
>>
>> Awaiting final review on the DAHDI reviewboard.
> 
> What does this mean?
> 
> confused,
> 
> greg k-h
> 

DAHDI is the name for drivers for hardware ports of Asterisk open source PBX.
This allows, for example, to route calls from Asterisk to PSTN (classic, analog telephone line) or ISDN.
There is good explanation on http://www.voip-info.org/wiki/view/Zaptel (Zaptel is pre-2008 name for DAHDI).

Maciej Szmigiero

