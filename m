Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab0KYITe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:19:34 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34701 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0KYITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:19:33 -0500
Message-ID: <4CEE1C0F.5060606@retis.net.pl>
Date: Thu, 25 Nov 2010 09:19:27 +0100
From: Grzegorz Chwesewicz <grzegorz.chwesewicz@retis.net.pl>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [regression] 2.6.37-rc1: Freeze while booting on HP nx6325
References: <4CED1AB8.80305@retis.net.pl> <201011241230.26262.bjorn.helgaas@hp.com>
In-Reply-To: <201011241230.26262.bjorn.helgaas@hp.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas pisze:
> On Wednesday, November 24, 2010 07:01:28 am Grzegorz Chwesewicz wrote:
>> Hi, I have a problem with 2.6.37-rc1. My HP nx6325 freezes during boot.
>> It happens after printing lines:
>>
>> [    0.298457] atiixp 0000:00:14.1: not 100% native mode: will probe
>> irqs later
>> [    0.298515]     ide0: BM-DMA at 0x7040-0x7047
>> [    0.298573] atiixp 0000:00:14.1: simplex device: DMA disabled
>> [    0.298625] ide1: DMA disabled
>> <Freeze>
> 
> I think this is the same problem as
> https://bugzilla.kernel.org/show_bug.cgi?id=23332
> 
> If you have more of the log, that would be useful, but I doubt you
> do because I don't think the nx6325 has a serial port.  

It doesn't have serial port, I tried with console on USB<->serial
converter, but it is initialized too late to dump something.

I do have
> a sample of that system, so I'm hoping to learn something about it
> today.

-- 
Greetings
Grzegorz Chwesewicz
grzegorz.chwesewicz@retis.net.pl
