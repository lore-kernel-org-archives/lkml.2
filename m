Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab0FJQ2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:28:34 -0400
Received: from clueserver.org ([65.102.45.174]:57444 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0FJQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:28:32 -0400
Date: Thu, 10 Jun 2010 09:28:32 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Jeff Garzik <jeff@garzik.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question on siig sata 3 controller
In-Reply-To: <4C10A81F.50801@garzik.org>
Message-ID: <Pine.LNX.4.64.1006100927190.20583@blackbox.fnordora.org>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2> <4C10A81F.50801@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Jeff Garzik wrote:

> On 06/10/2010 12:39 AM, Alan wrote:
>> Does anyone know the status of the SIIG DP SATA 6Gb/s 2S1P PCIe (Part
>> number: SC-SA0E12-S1)?
>> 
>> I am encountering problems writing a large quantity through this
>> controller and I want to see if there is a way to fix this.  The pci ids
>> do not appear to be referenced in the kernel.
>> 
>> Are any of the siig sata controllers supported? Is there some issue with
>> them supporting Linux that I am not aware of?
>> 
>> Here is the lspci data:
>> 
>> 05:00.0 SATA controller: Device 1b4b:9123 (rev 11) (prog-if 01 [AHCI 1.0])
>> 	Subsystem: Device 1b4b:9123
>> 	Flags: bus master, fast devsel, latency 0, IRQ 30
>> 	I/O ports at dc00 [size=8]
>> 	I/O ports at d880 [size=4]
>> 	I/O ports at d800 [size=8]
>> 	I/O ports at d480 [size=4]
>> 	I/O ports at d400 [size=16]
>> 	Memory at f9fff800 (32-bit, non-prefetchable) [size=2K]
>> 	Expansion ROM at f9fe0000 [disabled] [size=64K]
>> 	Capabilities:<access denied>
>> 	Kernel driver in use: ahci
>
> What issues are you seeing?
>
> The 'ahci' driver is aware of this controller...

If you write a large amount of data to the drive (about 6-8 gigs+) the 
drive will error out and disconnect.

I will post the string of error messages when I get home.

-- 
Truth is stranger than fiction because fiction has to make sense.
