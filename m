Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab0E3SqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 14:46:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57654 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0E3SqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 14:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JKamT+dgZyP2r0bOU7za1Fa8+wq+v66j166btoT54I+K5RXn/EFopX7sYalSLR/mhI
         Akphkq7Up5QFjwpmfq1BVKS4vKRUQ1EwZv6lfpGBL5OWZb0lOaGlGPsNcb5DTZi+KIY5
         JuqPQWyFd8C7S2hajSTkcnU8MR6PJdjYO+liY=
Message-ID: <4C02B104.4010900@gmail.com>
Date: Sun, 30 May 2010 12:40:04 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: via 8237 sata errors
References: <201005292046.06344.tfjellstrom@strangesoft.net>
In-Reply-To: <201005292046.06344.tfjellstrom@strangesoft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2010 08:46 PM, Thomas Fjellstrom wrote:
> I'm getting a rather nasty set of messages from dmesg when trying to use
> a couple SATA II WD 2TB Green drives with an older system (via 8237 based).
> They seem to work fine on a newer p35 based system.

..

> [  283.308963] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  283.309007] ata2.00: BMDMA stat 0x4
> [  283.309045] ata2.00: failed command: READ DMA
> [  283.309089] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in
> [  283.309091]          res 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error)
> [  283.309171] ata2.00: status: { DRDY ERR }
> [  283.309207] ata2.00: error: { ABRT }
> [  283.324886] ata2.00: configured for UDMA/133
> [  283.324904] ata2: EH complete

It's not really clear why the drive is returning command aborted on a 
read, there's no other error bits to indicate an uncorrectable error or 
a CRC error. Is it only the one drive that's giving the errors?
