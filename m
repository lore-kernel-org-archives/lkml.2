Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0GLNgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:36:19 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:48932 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0GLNgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:36:18 -0400
Date: Mon, 12 Jul 2010 09:38:26 -0400
From: Woody Suwalski <terraluna977@gmail.com>
To: Lee Jones <ljkenny@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linuxfoundation.org
Message-ID: <4C3B1AD2.6060900@gmail.com>
In-Reply-To: <4C3B071D.10505@gmail.com>
References: <4C3B071D.10505@gmail.com>
Subject: Re: [Upstream] Stop ARM boards crashing with CUPS is loaded
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SeaMonkey/2.0.4
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Jones wrote:
> Please find attached a patch which rectifies the following bug.
>
> When CUPS loads, it tries to load several drivers that it may need.
> When one of these drivers, specifically parport_pc is loaded on ARM
> based systems, it causes a segmentation fault as the address is not
> writable on non-PC based architectures. This code prevents this
> driver from being compiled on said architectures.
>
> Kind regards,
> Lee
>    
Not exactly true. Netwinders based on Armc4l SA110 have implemeted 
Parallel port hardware.
It can be used for PP-CDroms and (of course) printing.

I do not claim that the platform is of a great importance anymore, but 
blanket statements to remove RTC or PPort or KBD from ARM are not correct...

Woody

