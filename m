Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab0HQUGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 16:06:16 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:35921
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab0HQUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 16:06:08 -0400
Date: Tue, 17 Aug 2010 22:05:59 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Brian Norris <norris@broadcom.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Nand support broken with v2.6.36-rc1
Message-ID: <20100817200559.GA4542@gibson.comsick.at>
References: <20100817113644.GA31317@gibson.comsick.at>
 <4C6AC037.7070205@broadcom.com>
 <20100817174704.GA1322@gibson.comsick.at>
 <4C6AD9C2.1070705@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6AD9C2.1070705@broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Aug 10 11:49, Brian Norris wrote:
> First, have you ever used any of the mtdutils? In particular,
> running the command "mtdinfo -a" and sending the output is helpful
> if you have the utility installed on your board.
hmm mtdinfo tries to open /sys/class/mtd/mtd0/dev which das not exist
the device is working ok as block device on the other hand so let's try
the next thing.

Output booting with a patched .36-rc1

[    0.279217] rbppc_nand_probe: MikroTik RouterBOARD 600 series NAND driver, version 0.0.2
[    0.287535] ID byte 0: 0xad
[    0.290373] ID byte 1: 0x76
[    0.293185] ID byte 2: 0xad
[    0.295985] ID byte 3: 0x76
[    0.298798] ID byte 4: 0xad
[    0.301610] ID byte 5: 0x76
[    0.304423] ID byte 6: 0xad
[    0.307223] ID byte 7: 0x76
[    0.310046] NAND device: Manufacturer ID: 0xad, Chip ID: 0x76 (Hynix NAND 64MiB 3,3V 8-bit)

Hope this helps...
