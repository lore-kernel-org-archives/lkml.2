Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab1FVSbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:31:05 -0400
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:42747 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab1FVSbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:31:03 -0400
Message-ID: <4E023455.8010606@genband.com>
Date: Wed, 22 Jun 2011 12:28:37 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
References: <20110618171946.GB3441@infomag.iguana.be>
In-Reply-To: <20110618171946.GB3441@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2011 18:28:38.0877 (UTC) FILETIME=[3498E0D0:01CC310A]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18216.001
X-TM-AS-Result: No--6.762000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2011 11:19 AM, Wim Van Sebroeck wrote:
> watchdog: WatchDog Timer Driver Core - Part 1
>
> The WatchDog Timer Driver Core is a framework
> that contains the common code for all watchdog-driver's.
> It also introduces a watchdog device structure and the
> operations that go with it.
>
> This is the introduction of this framework. This part
> supports the minimal watchdog userspace API (or with
> other words: the functionality to use /dev/watchdog's
> open, release and write functionality as defined in
> the simplest watchdog API). Extra functionality will
> follow in the next set of patches.


Have you thought about callback support for systems that support a 
two-stage watchdog?  That way we could do something useful (preserve 
system memory using kdump, for instance) rather than just getting 
whacked by the hardware.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
