Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1ICKGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 06:06:46 -0400
Received: from lucidpixels.com ([72.73.18.11]:55931 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1ICKGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 06:06:43 -0400
Date: Sat, 3 Sep 2011 06:06:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.1.0-rc2: irq/112-eth0-Tx: page allocation failure: (w/frame
 pointers enabled)
In-Reply-To: <201109031049.00728.maciej.rutecki@gmail.com>
Message-ID: <alpine.DEB.2.02.1109030605590.1448@p34.internal.lan>
References: <alpine.DEB.2.02.1108260802590.14539@p34.internal.lan> <201109031049.00728.maciej.rutecki@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Sep 2011, Maciej Rutecki wrote:

> On pi?tek, 26 sierpnia 2011 o 14:14:12 Justin Piszcz wrote:
>> Hello,
>>
>> Why does this occur on a machine with 48GB of memory (used mainly as a
>> router) and backup server, is it a kernel bug?
>>
>
> It's regression? Any older kernel works OK?

Hi,

It has been occurring since 'threadirqs' was enabled.

Justin.

