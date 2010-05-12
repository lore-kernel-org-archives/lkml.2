Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0ELGBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:01:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52911 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0ELGBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lILLP3D+U0a8XViJcZyndKt8cxnEvx4gJye0eRqskOxVCbipYFPitenlKFCLah4zji
         TFWhpU3Kwzw2c1T6loBCXnXWbYP/MXEwAbawbT2SdnZasPvptRoNakycuRhfRx7Sxtdk
         cfxKn6AKeJ2ad9CXGGU6tuhfkv86FCdKAJtVI=
Message-ID: <4BEA4438.4030608@garzik.org>
Date: Wed, 12 May 2010 02:01:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Phil Turmel <pturmel-kernel@turmel.org>
CC: Phil Reynolds <phil-linux@tinsleyviaduct.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com> <4BE964C2.1010702@turmel.org> <20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com> <4BE9A1B3.3020208@turmel.org> <4BE9C796.7080605@garzik.org> <4BEA0E54.4080208@turmel.org>
In-Reply-To: <4BEA0E54.4080208@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 10:11 PM, Phil Turmel wrote:
> Hi Jeff,
>
> On 05/11/2010 05:09 PM, Jeff Garzik wrote:
>> On 05/11/2010 02:28 PM, Phil Turmel wrote:
>>> On 05/11/2010 01:21 PM, Phil Reynolds wrote:
>>>> Quoting "Phil Turmel"<pturmel-kernel@turmel.org>:
>>>>
>>>>> I have a similar chipset in my office server: 88SE6145.  If yours
>>>>> can run
>>>>> in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel
>>>>> command
>>>>> line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I
>>>>> have
>>>>> ahci built-in, and no initramfs, so I put the option in my grub.conf.)
>>>>
>>>> Neither works for me unfortunately.
>>>>
>
> [snip /]
>
>> sata_mv is not related to this hardware.
>>
>> pata_marvell works with 6101/6121/6141/6145 PATA ports.
>>
>> ahci works with 6101/6121/6141/6145 SATA ports, with marvell_enable=1.
>>
>>      Jeff
>
> I think you might have me (Phil T) confused with the original poster, Phil
> Reynolds [1].

No confusion.  You suggested blacklisting sata_mv, and I note above that 
sata_mv has nothing to do with the hardware in question.

	Jeff



