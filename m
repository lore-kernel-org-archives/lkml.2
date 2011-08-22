Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab1HVBEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:04:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53803 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1HVBEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110822001121.GN25996@one.firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	<CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
	<20110821231354.GL25996@one.firstfloor.org>
	<CACqU3MUAuMMC0c1Aesb3-oSzRXw4ddRYtjKDYovXewbCFL6dFg@mail.gmail.com>
	<20110822001121.GN25996@one.firstfloor.org>
Date: Sun, 21 Aug 2011 21:04:04 -0400
Message-ID: <CACqU3MWuQKVVwtP8hcUd1a3kcG3+NOyFz+meJM1XW6vo9H6HFQ@mail.gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: Arnaud Lacombe <lacombar@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 21, 2011 at 8:11 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> It does not work if / on a ROM, unless you start using trampoline
>> partition, but this is starting to become really convoluted...
>
> On a ROM you never change the kernel.
>
For this particular board, the kernel is on a small read-write NOR
flash, and the userland on write-protected NAND chip.

> Besides who uses ROMs now when there is flash?
>
this is totally irrelevant to the problem...

 - Arnaud
