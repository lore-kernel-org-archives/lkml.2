Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2IOXiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 19:38:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63848 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2IOXiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 19:38:04 -0400
Date: Sat, 15 Sep 2012 19:38:00 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu
To: Parag Warudkar <parag.lkml@gmail.com>
cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, rydberg@euromail.se, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
In-Reply-To: <alpine.DEB.2.02.1209151918210.2271@ubuntu>
Message-ID: <alpine.DEB.2.02.1209151936220.2271@ubuntu>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu> <20120915225841.GA3816@roeck-us.net> <alpine.DEB.2.02.1209151918210.2271@ubuntu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Sep 2012, Parag Warudkar wrote:

> 
> Yeah, that would fix the code to match what it says and eliminate most 
> failures. But in my testing sometimes it needed a max wait of 57344 us - 
> I wrote a separate patch to instrument it by bumping up max wait in 
> increments of 0x2000 until it no longer failed under my normal workloads. 

Of course I meant 57 us instead of 57344 which I remembered from my 
unconverted debug printks.

Parag
