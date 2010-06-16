Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0FPI5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:57:46 -0400
Received: from science.horizon.com ([71.41.210.146]:60177 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752068Ab0FPI5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:57:45 -0400
Date: 16 Jun 2010 04:57:43 -0400
Message-ID: <20100616085743.16572.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: andi@firstfloor.org
Subject: Re: Hardware Error Kernel Mini-Summit
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, tony.luck@intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...and the numbers that come out of this may have no relation
> to your motherboard labels at all. What do you do then? 
> Read schemantics again?  Or do binary search on the DIMM again
> like Eric suggested? 

Or make a guess and see if it works, or STFW for someone else who figured it
out, or read chipset docs, or see if the SPD addresses correspond in a
sensible way, or extrapolate from another board with the same NB and
BIOS vendor, or...

One of the big advantages of Linux/*BSD over certain other x86 operating
systems is they don't try so hard to be user-friendly that they're
expert-hostile.  "Your computer is fucked up, please consult your
system administrator" isn't much help to the poor system administrator.

So while it's fine to *try* to translate to a DIMM slot using BIOS info,
please also report whatever can be figured out without trusting the BIOS.
So if I find it's in error, I can report everything needed to write
an override table entry.

Without the BIOS, it's a PITA, but the correspondence between /CSx lines
and DIMM slot locations can be figured out, and if necessary, I can publish
a web page with the mappings.

	"We do not trust BIOS tables, because BIOS writers are invariably
	totally incompetent crack-addicted monkeys. If they weren't,
	they wouldn't be BIOS writers. QED."		-- Linus
		http://marc.info/?l=linux-kernel&m=127498023108564
