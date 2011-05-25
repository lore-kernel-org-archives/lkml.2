Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab1EZA0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:26:25 -0400
Received: from lucidpixels.com ([75.144.35.66]:53627 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab1EZA0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:26:24 -0400
Date: Wed, 25 May 2011 19:49:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: e1000-devel@lists.sourceforge.net, linux-net@vger.kernel.org
Subject: Re: 2.6.39: kernel igb and e1000e-1.3.17 driver broken?
In-Reply-To: <alpine.DEB.2.02.1105251941550.9120@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1105251947490.320@p34.internal.lan>
References: <alpine.DEB.2.02.1105251926070.9120@p34.internal.lan> <alpine.DEB.2.02.1105251941550.9120@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 May 2011, Justin Piszcz wrote:

>
> On Wed, 25 May 2011, Justin Piszcz wrote:
>
>> Hello,
>>

The issue was, in Debian you want, e.g.:

# in /etc/network/interfaces

auto eth1
iface eth1 inet dhcp

Or similar for each NIC, otherwise, by default they are down..

Justin.

