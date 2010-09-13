Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0IMOwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:52:53 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:57448 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0IMOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:52:52 -0400
Message-ID: <4C8E3ABF.90309@xs4all.nl>
Date: Mon, 13 Sep 2010 16:52:47 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
References: <4BFA52C3.4080006@xs4all.nl>	<20100526120236.4a849b5b.randy.dunlap@oracle.com>	<4C021507.6020703@xs4all.nl>	<4C02B3AB.3040405@gmail.com>	<4C0324B8.8070304@xs4all.nl> <AANLkTikuaPxA9Xnzc1bCJ5YHRlPZ1AcBSrYJ5lqryaMY@mail.gmail.com>
In-Reply-To: <AANLkTikuaPxA9Xnzc1bCJ5YHRlPZ1AcBSrYJ5lqryaMY@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-05-31 06:00, Robert Hancock wrote:
> On Sun, May 30, 2010 at 8:53 PM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>> On 2010-05-30 20:51, Robert Hancock wrote:
>>> On 05/30/2010 01:34 AM, Udo van den Heuvel wrote:
>>>> The board has VIA C7 CPU and VIA CX700M2 Unified Digital Media IGP
>>>> chipset which supports HPET.
>>>>
>>>> Can it be that the kernel lacks support for CX700 hpet?
>>>> Or is it a matter of getting the BIOS upgrade to work?
>>>
>>> Your current BIOS doesn't provide an HPET ACPI table, which is the way
>>> it's supposed to indicate support. The kernel only supports
>>> force-enabling HPET on VIA for VT8235 and VT8237.
>>
>> So yes, I should try the BIOS upgrade first?
> 
> If they did add an HPET table entry, it should help, yes..

Is there a workaround?
VIA was not so helpfull: the bios flash tool they have on the site does
not recognise the board as a VIA board.
Also they state the latest BIOS will not add HPET to ACPI table.

So what else can I do to enable HPET?

Kind regards,
Udo
