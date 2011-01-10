Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1AJRIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:08:24 -0500
Received: from lo.gmane.org ([80.91.229.12]:35041 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab1AJRIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:08:22 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: CPU Initiated DMA
Date: Mon, 10 Jan 2011 12:08:00 -0500
Message-ID: <8739p0u1ov.fsf@inspiron.ap.columbia.edu>
References: <87mxncv3ge.fsf@inspiron.ap.columbia.edu>
	<AANLkTi=QV7wF3Z7J8eh3MkOJ1K=ZNLgHFinX8dJSuYeJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ebox.rath.org
Mail-Copies-To: never
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:C1I2mGZxrW0RehiLrUM0KdLxKbY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> 2011/1/8 Nikolaus Rath <Nikolaus@rath.org>:
> Hi,
>
>> Hello,
>>
>> I want to write a driver for a rather dumb PCI card, which cannot become
>> bus master itself. Is it possible to use a DMA controller on the
>> mainboard to still transfer data to the card without occupying the CPU?
>>
>> (I believe this is the way DMA used to work on ISA cards, but do recent
>> x86 systems still have a DMA controller for the CPU?)
>>
>> Any pointers are greatly appreciated. I looked into "Linux Device
>> Drivers", but the DMA chapter seems to be only about the device becoming
>> busmaster.
>
> Generally speaking, you can do it certainly if there is dma controller on
> your system.

That sounds promising, thanks. How do I find out if my system has a DMA
controller? (I don't need general C code, I just want to check if I'll
be able to test the driver on my system).


Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C

