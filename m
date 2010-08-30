Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab0H3HgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:36:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53782 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0H3HgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ChV+65Me1MUKxUZcB/qwmVqwr97FvI5njCJaiheQgiAbDh5yQGHnCG4PSAFioU1Fad
         UpTjtWTozIlxaWFDd0kxuHOq+NX0kySGTyDo9J9FXz2JzFFwzgSS91Y6by0IAcNYMnJ5
         YZPS3GeTDcx3LME5DorHm65iA34Z2RybrStwk=
Message-ID: <4C7B5F64.30205@suse.cz>
Date: Mon, 30 Aug 2010 09:36:04 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        lenb@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>	<4C27E965.80508@gmail.com>	<4C283D84.6080504@suse.cz>	<20100628171410.GA27367@srcf.ucam.org>	<4C290245.2040001@suse.cz>	<20100628204820.GA32503@srcf.ucam.org>	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>	<4C2A3E27.4060407@suse.cz>	<AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com>	<4C2B0C73.9050200@suse.cz>	<4C3278C8.60503@gmail.com>	<4C447D6D.5060801@suse.cz>	<AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com>	<4C456C69.60606@suse.cz>	<4C737E9F.7060107@gmail.com> <AANLkTin7eUS7_y9J8iY1XFi2bRnpm+WqFNT_tBopwyCK@mail.gmail.com>
In-Reply-To: <AANLkTin7eUS7_y9J8iY1XFi2bRnpm+WqFNT_tBopwyCK@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 01:25 AM, Robert Hancock wrote:
> On Tue, Aug 24, 2010 at 2:11 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> So, to sum up:
>> 1) acpi routing enabled (no kernel parameter) => ports 4+5 defunct.
>> ports 4+5+6+7 are all on irq 11
>>
>> 2) acpi routing disabled (acpi=noirq) => all ports working, 4+5 on irq
>> 10, 6+7 on irq 11
>>
>> 3) with the quirk [1] and acpi routing enabled => all ports working,
>> ports 4+5 on irq 10, 6+7 on irq 11
>>
>> 4) in windows => 4+5+6+7 are all on irq 9 and the ports are all working.
>>
>> Any ideas what this means? Especially point 4)?
>>
>> [1] http://lkml.org/lkml/2010/6/27/85
> 
> I think that's the key question. Is Windows actually using ACPI on
> that machine at all? (Check the computer type in Device Manager and
> see if it mentions ACPI.)

Yes, there is Computer->ACPI PC.

thanks,
-- 
js
suse labs
