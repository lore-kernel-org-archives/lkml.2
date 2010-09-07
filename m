Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab0IGLC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 07:02:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62418 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0IGLCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 07:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Vivp1ULO79Xt7Vy3zrAq22DZSGeOb0kjzqBOswC1GsL6j+nT9b/s5Wg+zp7zGDHSbI
         H6XBCsGXno6w/Om/EI/lAQe03wdWyOlf4N9XUZ6iTYPwdoP0118phXcOEB7Ol3QUZfn4
         CyhtdfUYDRon7FoIYNIpcvHN2mHK5zAKzlWfg=
Message-ID: <4C861BB9.2000707@gmail.com>
Date: Tue, 07 Sep 2010 13:02:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
CC: Robert Hancock <hancockrwd@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>	<4C27E965.80508@gmail.com>	<4C283D84.6080504@suse.cz>	<20100628171410.GA27367@srcf.ucam.org>	<4C290245.2040001@suse.cz>	<20100628204820.GA32503@srcf.ucam.org>	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>	<4C2A3E27.4060407@suse.cz>	<AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com>	<4C2B0C73.9050200@suse.cz>	<4C3278C8.60503@gmail.com>	<4C447D6D.5060801@suse.cz>	<AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com>	<4C456C69.60606@suse.cz>	<4C737E9F.7060107@gmail.com> <AANLkTin7eUS7_y9J8iY1XFi2bRnpm+WqFNT_tBopwyCK@mail.gmail.com> <4C7B5F64.30205@suse.cz>
In-Reply-To: <4C7B5F64.30205@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 09:36 AM, Jiri Slaby wrote:
> On 08/25/2010 01:25 AM, Robert Hancock wrote:
>> On Tue, Aug 24, 2010 at 2:11 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>> So, to sum up:
>>> 1) acpi routing enabled (no kernel parameter) => ports 4+5 defunct.
>>> ports 4+5+6+7 are all on irq 11
>>>
>>> 2) acpi routing disabled (acpi=noirq) => all ports working, 4+5 on irq
>>> 10, 6+7 on irq 11
>>>
>>> 3) with the quirk [1] and acpi routing enabled => all ports working,
>>> ports 4+5 on irq 10, 6+7 on irq 11
>>>
>>> 4) in windows => 4+5+6+7 are all on irq 9 and the ports are all working.
>>>
>>> Any ideas what this means? Especially point 4)?
>>>
>>> [1] http://lkml.org/lkml/2010/6/27/85
>>
>> I think that's the key question. Is Windows actually using ACPI on
>> that machine at all? (Check the computer type in Device Manager and
>> see if it mentions ACPI.)
> 
> Yes, there is Computer->ACPI PC.

Any ideas here, please? Is there anything what I might try?

thanks,
-- 
js
