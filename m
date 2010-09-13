Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab0IMXQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 19:16:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40666 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0IMXQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 19:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OB3y13ugnU25a85pAOl4pQG7UFgS5glHDmNXzF1BUySYRFWCdGtRhleNhbIq+ERyok
         qEepm5wrpS9X/4GxZsLgSlPXMFWwxR8jPXkqFk5gKDuMOr3NXDuVUIJa2ECfFTsaD8Up
         CIk1yLAe81pCnAa+Py8SrXSwpOTrrCA/sXCqQ=
MIME-Version: 1.0
In-Reply-To: <4C8E3ABF.90309@xs4all.nl>
References: <4BFA52C3.4080006@xs4all.nl>
	<20100526120236.4a849b5b.randy.dunlap@oracle.com>
	<4C021507.6020703@xs4all.nl>
	<4C02B3AB.3040405@gmail.com>
	<4C0324B8.8070304@xs4all.nl>
	<AANLkTikuaPxA9Xnzc1bCJ5YHRlPZ1AcBSrYJ5lqryaMY@mail.gmail.com>
	<4C8E3ABF.90309@xs4all.nl>
Date: Mon, 13 Sep 2010 17:16:33 -0600
Message-ID: <AANLkTintq=gXvFC9BW_cv=MSqBWHCx7SD9o1CWHOYTsj@mail.gmail.com>
Subject: Re: hpet timers gone?
From: Robert Hancock <hancockrwd@gmail.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 8:52 AM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> On 2010-05-31 06:00, Robert Hancock wrote:
>> On Sun, May 30, 2010 at 8:53 PM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>>> On 2010-05-30 20:51, Robert Hancock wrote:
>>>> On 05/30/2010 01:34 AM, Udo van den Heuvel wrote:
>>>>> The board has VIA C7 CPU and VIA CX700M2 Unified Digital Media IGP
>>>>> chipset which supports HPET.
>>>>>
>>>>> Can it be that the kernel lacks support for CX700 hpet?
>>>>> Or is it a matter of getting the BIOS upgrade to work?
>>>>
>>>> Your current BIOS doesn't provide an HPET ACPI table, which is the way
>>>> it's supposed to indicate support. The kernel only supports
>>>> force-enabling HPET on VIA for VT8235 and VT8237.
>>>
>>> So yes, I should try the BIOS upgrade first?
>>
>> If they did add an HPET table entry, it should help, yes..
>
> Is there a workaround?
> VIA was not so helpfull: the bios flash tool they have on the site does
> not recognise the board as a VIA board.
> Also they state the latest BIOS will not add HPET to ACPI table.
>
> So what else can I do to enable HPET?

At this point, not much, unless you can track down the chipset
information that would allow us to implement force enabling HPET on
that chipset..
