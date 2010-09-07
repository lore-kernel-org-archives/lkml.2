Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0IGOk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:40:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39178 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0IGOkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dO1MTXwplYaUuKUXpAGtVUQw3k9qWLZaEEIr9ZEyLNs8GsiYt2ZeQSJnQN9DeOtKKy
         G01+xfZZx0fs420mxIEnre2KSBURZnA4B02fJZPQunwqZ/nqLo7HhrbN4S5UJNffnbYZ
         184llfvGCfjdJceTLhRytZIySZjKcI/cht+04=
MIME-Version: 1.0
In-Reply-To: <4C861BB9.2000707@gmail.com>
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>
	<4C27E965.80508@gmail.com>
	<4C283D84.6080504@suse.cz>
	<20100628171410.GA27367@srcf.ucam.org>
	<4C290245.2040001@suse.cz>
	<20100628204820.GA32503@srcf.ucam.org>
	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>
	<4C2A3E27.4060407@suse.cz>
	<AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com>
	<4C2B0C73.9050200@suse.cz>
	<4C3278C8.60503@gmail.com>
	<4C447D6D.5060801@suse.cz>
	<AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com>
	<4C456C69.60606@suse.cz>
	<4C737E9F.7060107@gmail.com>
	<AANLkTin7eUS7_y9J8iY1XFi2bRnpm+WqFNT_tBopwyCK@mail.gmail.com>
	<4C7B5F64.30205@suse.cz>
	<4C861BB9.2000707@gmail.com>
Date: Tue, 7 Sep 2010 08:40:18 -0600
Message-ID: <AANLkTi=bnr-tnTkCWuSqYhLkfnXhJQjSyLDTt_5RyiAN@mail.gmail.com>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
From: Robert Hancock <hancockrwd@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 5:02 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 08/30/2010 09:36 AM, Jiri Slaby wrote:
>> On 08/25/2010 01:25 AM, Robert Hancock wrote:
>>> On Tue, Aug 24, 2010 at 2:11 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>> So, to sum up:
>>>> 1) acpi routing enabled (no kernel parameter) => ports 4+5 defunct.
>>>> ports 4+5+6+7 are all on irq 11
>>>>
>>>> 2) acpi routing disabled (acpi=noirq) => all ports working, 4+5 on irq
>>>> 10, 6+7 on irq 11
>>>>
>>>> 3) with the quirk [1] and acpi routing enabled => all ports working,
>>>> ports 4+5 on irq 10, 6+7 on irq 11
>>>>
>>>> 4) in windows => 4+5+6+7 are all on irq 9 and the ports are all working.
>>>>
>>>> Any ideas what this means? Especially point 4)?
>>>>
>>>> [1] http://lkml.org/lkml/2010/6/27/85
>>>
>>> I think that's the key question. Is Windows actually using ACPI on
>>> that machine at all? (Check the computer type in Device Manager and
>>> see if it mentions ACPI.)
>>
>> Yes, there is Computer->ACPI PC.
>
> Any ideas here, please? Is there anything what I might try?

I'd suggest opening a report on kernel.org bugzilla under ACPI and
attach the acpidump output..
