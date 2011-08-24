Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab1HXUeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:34:46 -0400
Received: from lucidpixels.com ([72.73.18.11]:59622 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab1HXUeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:34:44 -0400
Date: Wed, 24 Aug 2011 16:34:43 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.0.1: irq/48-eth1-rx-: page allocation failure: order:1,
 mode:0x20
In-Reply-To: <201108242223.25628.maciej.rutecki@gmail.com>
Message-ID: <alpine.DEB.2.02.1108241633520.14539@p34.internal.lan>
References: <alpine.DEB.2.02.1108180610310.11234@p34.internal.lan> <201108242223.25628.maciej.rutecki@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Aug 2011, Maciej Rutecki wrote:

> On czwartek, 18 sierpnia 2011 o 12:11:35 Justin Piszcz wrote:
>> Hello,
>>
>> Mem:   8194732k total,  8061488k used,   133244k free,  3211684k buffers
>> Swap: 16787772k total,        0k used, 16787772k free,  3938768k cached
>>
>> Any thoughts on what caused the error below?
>> No swap is used.
>>
>
> It's regression?

Hi,

Can't say for certain as I moved to host I used a while ago, just wanted to
note it and/see if anyone else had reported similar events/if there was a
known issue somewhere.

Justin.

