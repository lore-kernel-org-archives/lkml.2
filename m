Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0DRQp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 12:45:26 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:56243 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab0DRQpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 12:45:24 -0400
Message-ID: <4BCB373F.4070400@gmail.com>
Date: Sun, 18 Apr 2010 17:45:51 +0100
From: Matt <tank.en.mate@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100216 Shredder/3.0.2pre
MIME-Version: 1.0
To: Oleg Kutkov <elenbert@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Network activity after route changes
References: <4BC9DB9A.9090605@gmail.com> <4BCAE9BC.3090609@gmail.com>
In-Reply-To: <4BCAE9BC.3090609@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/10 12:15, Oleg Kutkov wrote:
> Hello.
> I try to send and receive ethernet packets on very low level in my 
> kernel module.
> When i change (add or delete entry) routin table (via route command) 
> my network is freeze for ~15 seconds and my application can't send and 
> receive any packets.
> Is it normal or bug somewhere in my application?
> Can i change this behavior of route system? Maybe change some 
> timeouts, or immediately flush route (rt_flush() ?) table?

Depending on your routing configuration the change may be causing the 
problem. Have you tried flushing the route cache (as opposed to the main 
routing table)?

# ip route flush table cache

matt
