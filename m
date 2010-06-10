Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab0FJTwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:52:40 -0400
Received: from smtp-out115.alice.it ([85.37.17.115]:1581 "EHLO
	smtp-out115.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0FJTwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:52:38 -0400
Message-ID: <4C11427F.5090007@libero.it>
Date: Thu, 10 Jun 2010 21:52:31 +0200
From: Massimiliano Galanti <massiblue@libero.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Brian Gordon <legerde@gmail.com>
CC: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Aerospace and linux
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>	<4C112E7B.1040101@nortel.com>	<AANLkTinIAKHVYKiILxQZXTr30K_Cr5EZQwRzNpYlLULw@mail.gmail.com>	<4C113BC2.6070000@libero.it>	<AANLkTikrKsMagIl0bmcDC4j98_MZrExyoduQXEy_ak3H@mail.gmail.com> <AANLkTin_r58efRXM609hT_nc-oO_ojPHzsgOU92bEI9s@mail.gmail.com>
In-Reply-To: <AANLkTin_r58efRXM609hT_nc-oO_ojPHzsgOU92bEI9s@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 19:52:33.0113 (UTC) FILETIME=[77809490:01CB08D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, not quite. See i.e. AXFS, or squashfs that are ro and flash 
oriented by design.

Anyway, if you're stuck with NTFS/VFAT and can't use NOR...

(Just curious of what technology are you relying on for storage)

Il 10/06/2010 21:42, Brian Gordon ha scritto:
> Sorry, I take it back.   This wont work for me because I wont have
> NOR.   Also, I only want the "in-place" to apply to read-only pages.
> This looks like all reads and writes get passed to the underlying
> storage and I can't suffer flash page erase/writes to update a
> variable. :)  The device will wear out and meaningful work would be
> starved.

-- 
Massimiliano
