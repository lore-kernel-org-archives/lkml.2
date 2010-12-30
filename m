Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab0L3WwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:52:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0L3WwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:52:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: carlos palma <carlos.palma@ono.com>
Subject: Re: [Bug #25402] kernel (2.6.37-8-generic_amd64) panic on boot (with message "map_single: bounce buffer is not DMA'ble) - possible regression !!!
Date: Thu, 30 Dec 2010 23:51:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.txE.R-7GNB@chimera> <4D1CFA99.1070701@ono.com>
In-Reply-To: <4D1CFA99.1070701@ono.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012302351.48156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 30, 2010, carlos palma wrote:
> I can confirm that this "regression" still exists with the kernel 
> 2.6.37-rc8.
> The Call Trace is basically the same:
> 
> ...
> Kernel panic - not syncing: map_single ...
> Pid 935, comm: NetworkManager Tainted
> call trace
> panic+oxbf/0x200
> ? default_spin_lock_flags+0x9/0x10
> ?swiotlb_tlb_map_single+0x1ce/0x250
> ?map_single+0x46/0x60
> swiotlb_map_page+0xa6/0xf
> ... and then the FREEZE ... only a hard reset brings to live (with 
> 2.6.36-2) Linux.

Thanks for the info.

Why did you put "regression" into double quotes?

Rafael
