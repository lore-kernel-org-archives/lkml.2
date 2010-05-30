Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0E3S5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 14:57:46 -0400
Received: from troy.hostgo.com ([64.62.143.130]:48439 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab0E3S5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 14:57:44 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: Re: via 8237 sata errors
Date: Sun, 30 May 2010 12:57:31 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org
References: <201005292046.06344.tfjellstrom@strangesoft.net> <4C02B104.4010900@gmail.com>
In-Reply-To: <4C02B104.4010900@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005301257.31839.tfjellstrom@strangesoft.net>
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

On May 30, 2010, Robert Hancock wrote:
> On 05/29/2010 08:46 PM, Thomas Fjellstrom wrote:
> > I'm getting a rather nasty set of messages from dmesg when trying to
> > use a couple SATA II WD 2TB Green drives with an older system (via
> > 8237 based). They seem to work fine on a newer p35 based system.
> 
> ..
> 
> > [  283.308963] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action
> > 0x0 [  283.309007] ata2.00: BMDMA stat 0x4
> > [  283.309045] ata2.00: failed command: READ DMA
> > [  283.309089] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0
> > dma 4096 in [  283.309091]          res
> > 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error) [ 
> > 283.309171] ata2.00: status: { DRDY ERR }
> > [  283.309207] ata2.00: error: { ABRT }
> > [  283.324886] ata2.00: configured for UDMA/133
> > [  283.324904] ata2: EH complete
> 
> It's not really clear why the drive is returning command aborted on a
> read, there's no other error bits to indicate an uncorrectable error or
> a CRC error. Is it only the one drive that's giving the errors?

I'm not entirely sure if its the same drive each time. I can make sure 
today. The fun part is it works fine in a different machine. Where as it 
will start erroring out like that almost right away in the via based 
machine. When its doing that, its also making some fairly scary (for a hard 
drive) noises, but since it doesn't do that in the p35 machine I'm really 
hoping it isn't the drive.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
