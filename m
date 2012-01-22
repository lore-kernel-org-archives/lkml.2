Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab2AVH5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 02:57:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52602 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2AVH5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 02:57:42 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: 3.2.1 unable to use my cd/dvd drive
Date: Sun, 22 Jan 2012 08:57:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAC9WiBgRDEf_-F4qk+0TD83Gpaw2BxGD+UyaX8aQNuGUCWGVBw@mail.gmail.com>
In-Reply-To: <CAC9WiBgRDEf_-F4qk+0TD83Gpaw2BxGD+UyaX8aQNuGUCWGVBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201220857.36170.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 14 stycznia 2012 o 19:33:42 Francis Moreau wrote:
> Hello,
> 
> I'm not sure that's related to the upgrade to 3.2.1 (actually I don't
> think so) but I'm unable to burn some DVD rw now.
> 
> I tried several DVDs but failing each time with:
> 
> [17418.653910] end_request: I/O error, dev sr0, sector 0
> [17418.654664] sr 1:0:0:0: [sr0] Unhandled sense code
> [17418.654669] sr 1:0:0:0: [sr0]  Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [17418.654673] sr 1:0:0:0: [sr0]  Sense Key : Medium Error [current]
> [17418.654679] sr 1:0:0:0: [sr0]  Add. Sense: Unable to recover
> table-of-contents
> [17418.654686] sr 1:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 04 00 00 00 02
> 00 [17418.654697] end_request: I/O error, dev sr0, sector 4096
> 
> Related drivers I'm using: sg, sr_mod, libata, sd_mod, scsi_mod
> 
> Could anybody tell me what's going on ?
> 
> Thanks

It is regression? Which last kernel works OK?

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
