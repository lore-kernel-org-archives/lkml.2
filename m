Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0EKTPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:15:54 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47523 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0EKTPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:15:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19433.44163.776781.931987@stoffel.org>
Date: Tue, 11 May 2010 15:14:11 -0400
From: "John Stoffel" <john@stoffel.org>
To: "Phil Reynolds" <phil-linux@tinsleyviaduct.com>
Cc: "Phil Turmel" <pturmel-kernel@turmel.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
In-Reply-To: <20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com>
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
	<4BE964C2.1010702@turmel.org>
	<20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Phil" == Phil Reynolds <phil-linux@tinsleyviaduct.com> writes:

Phil> Quoting "Phil Turmel" <pturmel-kernel@turmel.org>:
>> I have a similar chipset in my office server: 88SE6145.  If yours can run
>> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel command
>> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
>> ahci built-in, and no initramfs, so I put the option in my grub.conf.)

Phil> Neither works for me unfortunately.

Can you post your dmesg output from both bootups?  Are there any
differences?  Also submit the lspci -vvv output as well, just so
people can help you better.

John
