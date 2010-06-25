Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0FYDkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 23:40:04 -0400
Received: from troy.hostgo.com ([64.62.143.130]:55647 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab0FYDkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 23:40:02 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc3 -- kernel BUG at mm/vmalloc.c:216! - invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Date: Thu, 24 Jun 2010 21:27:36 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.dmz.10-liquorix-amd64; KDE/4.4.4; x86_64; ; )
Cc: Miles Lane <miles.lane@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <AANLkTimYUy0tCvGHf_Qtz0tUG7XVms9i3MOz03m28Jin@mail.gmail.com>
In-Reply-To: <AANLkTimYUy0tCvGHf_Qtz0tUG7XVms9i3MOz03m28Jin@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201006242127.36861.tfjellstrom@strangesoft.net>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On June 23, 2010, Miles Lane wrote:
> I ran:  "find /sys | xargs head"
> 
[snip]

I was curious as to what would happen on my machine, so I tried it and got 
this:

ACPI Warning: Incorrect checksum in table [GSCI] - F0, should be D0 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [SSDT] - 28, should be B7 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [SSDT] - 37, should be C7 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [GSCI] - F0, should be D0 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [ATKG] - 67, should be 83 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [SSDT] - 28, should be B7 
(20100121/tbutils-314)
ACPI Warning: Incorrect checksum in table [SSDT] - 37, should be C7 
(20100121/tbutils-314)

I tried it twice, and it seems to have shown the messages twice. Is this a 
bios problem? Whats going on here?

This is on a Lenovo SL500 laptop, w/ core2duo cpu, 4G ram, running linux 
2.6.34 in full 64bit mode.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
