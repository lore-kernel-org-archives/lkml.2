Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab1FVUZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:25:49 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:8366 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180Ab1FVUZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:25:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAENPAk5tgwPS/2dsb2JhbABTpxB4iHMCwH0Ohh8EoXg
Date: Wed, 22 Jun 2011 22:25:46 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Chris Friesen <chris.friesen@genband.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110622202546.GH26745@infomag.iguana.be>
References: <20110618171946.GB3441@infomag.iguana.be> <4E023455.8010606@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E023455.8010606@genband.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

>> watchdog: WatchDog Timer Driver Core - Part 1
>>
>> The WatchDog Timer Driver Core is a framework
>> that contains the common code for all watchdog-driver's.
>> It also introduces a watchdog device structure and the
>> operations that go with it.
>>
>> This is the introduction of this framework. This part
>> supports the minimal watchdog userspace API (or with
>> other words: the functionality to use /dev/watchdog's
>> open, release and write functionality as defined in
>> the simplest watchdog API). Extra functionality will
>> follow in the next set of patches.
>
>
> Have you thought about callback support for systems that support a  
> two-stage watchdog?  That way we could do something useful (preserve  
> system memory using kdump, for instance) rather than just getting  
> whacked by the hardware.

No, goal was to first have an API that reduces the existing functionality
that we copy over in each driver.
But it's indeed a feauture where we should look at in the future.
Question will be: how will we implement it.

Kind regards,
Wim.

