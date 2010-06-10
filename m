Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab0FJIxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:53:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42126 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0FJIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WsLke+F91G+wS06al/6EIgzzs1tKs8MAuxt5xdRlGko4K8Ei6e5QimEbIkDKnhVBcH
         GCmiZgiKExzH0L60+BUhyy0aM0QF40Eteq5UhSxtVcoKgqOj1HpKdZiM3cBqhpiD05SY
         IBlCdm8TcqBitjkru49pG2G0rKGZfVah3YwSw=
Message-ID: <4C10A81F.50801@garzik.org>
Date: Thu, 10 Jun 2010 04:53:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan <alan@clueserver.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question on siig sata 3 controller
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2>
In-Reply-To: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 12:39 AM, Alan wrote:
> Does anyone know the status of the SIIG DP SATA 6Gb/s 2S1P PCIe (Part
> number: SC-SA0E12-S1)?
>
> I am encountering problems writing a large quantity through this
> controller and I want to see if there is a way to fix this.  The pci ids
> do not appear to be referenced in the kernel.
>
> Are any of the siig sata controllers supported? Is there some issue with
> them supporting Linux that I am not aware of?
>
> Here is the lspci data:
>
> 05:00.0 SATA controller: Device 1b4b:9123 (rev 11) (prog-if 01 [AHCI 1.0])
> 	Subsystem: Device 1b4b:9123
> 	Flags: bus master, fast devsel, latency 0, IRQ 30
> 	I/O ports at dc00 [size=8]
> 	I/O ports at d880 [size=4]
> 	I/O ports at d800 [size=8]
> 	I/O ports at d480 [size=4]
> 	I/O ports at d400 [size=16]
> 	Memory at f9fff800 (32-bit, non-prefetchable) [size=2K]
> 	Expansion ROM at f9fe0000 [disabled] [size=64K]
> 	Capabilities:<access denied>
> 	Kernel driver in use: ahci

What issues are you seeing?

The 'ahci' driver is aware of this controller...

	Jeff



