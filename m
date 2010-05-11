Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0EKQx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:53:28 -0400
Received: from topdeck.tinsleyviaduct.com ([62.49.246.82]:55087 "EHLO
	topdeck.tinsleyviaduct.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540Ab0EKQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:53:26 -0400
Message-ID: <20100511175323.12391pgvoja7f62r@topdeck.tinsleyviaduct.com>
Date: Tue, 11 May 2010 17:53:23 +0100
From: "Phil Reynolds" <phil-linux@tinsleyviaduct.com>
To: "Phil Turmel" <pturmel-kernel@turmel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
	<4BE964C2.1010702@turmel.org>
In-Reply-To: <4BE964C2.1010702@turmel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Phil Turmel" <pturmel-kernel@turmel.org>:

> I have a similar chipset in my office server: 88SE6145.  If yours can run
> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel command
> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
> ahci built-in, and no initramfs, so I put the option in my grub.conf.)

Tried in grub.conf already, no success... will try the modprobe.conf  
way in case of differing mileage.

> My Marvell chipset has both SATA and PATA ports... the PATA ports are
> non-functional when the ahci driver runs the chipset.  Your mileage may
> vary.

I gather the PATA port on my board is on the Southbridge instead - but  
I don't use it anyway.

-- 
Phil Reynolds
email: phil-linux@tinsleyviaduct.com
Not subscribed to lkml - please CC replies to me

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

