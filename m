Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1AKGgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 01:36:36 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:46387 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1AKGg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 01:36:29 -0500
Message-ID: <4D2BFA08.5030104@ahsoftware.de>
Date: Tue, 11 Jan 2011 07:34:48 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: ARM: relocation out of range (when loading a module)
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.01.2011 23:26, schrieb Nicolas Pitre:
> On Mon, 10 Jan 2011, Alexander Holler wrote:
>
>> I've build a kernel 2.6.37 for an armv5-device which includes an initramfs of
>> about 16MB (uncompressed, result is a kernel of about 6MB) and I now getting
>> errors when trying to load a module (which is included in that initramfs):
>
> Do you really need to have such a bit initramfs?

Not really, but it is handier to use than a separate file.

> What you can do to work around this issue is to load your initramfs
> separately as a initrd ramdisk image. , and not combine it with the
> kernel image.

Point is that I would like to understand why including an initramfs has 
such consequences.

I have to search for some pictures which are explaining the memory 
layout (never had any interested in that before).

I assume some memory near the kernel is reserved for the modules and an 
initramfs will come inbetween the kernel and the reserved memory for 
modules.

Regards,

Alexander
