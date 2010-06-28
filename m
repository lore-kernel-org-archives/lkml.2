Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0F1GNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:13:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60572 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0F1GNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TxZbE4zysPEA0rShNUfqMmJeuQ/Wy3TA35YymBMULlD12MQCpH4bmQ+LSevc+H6OQz
         PfC/tKw/7adonxEVOmPCk0yz9onkAKt5KwIGWVCEzHPQc0WA8tucJXzQ/SiMn1n84jym
         hyfkP5AFndL1ZS3NmLGr3ZqKNWwyznf2COU1Y=
Message-ID: <4C283D84.6080504@suse.cz>
Date: Mon, 28 Jun 2010 08:13:24 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: lenb@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz> <4C27E965.80508@gmail.com>
In-Reply-To: <4C27E965.80508@gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 02:14 AM, Robert Hancock wrote:
> On 06/27/2010 03:21 PM, Jiri Slaby wrote:
>> On IBM Bartolo machines, cards in 00:09.0 are defunct (if use
>> interrupts). DSDT says that this slot (with function 0, i.e. pin A) is
>> routed to \_SB_.PCI0.PIB_.LNKB. But it's not, it's wired to LNKC, so
>> interrupts are misrouted. Add a quirk for this to workaround the
>> issue.
> 
> That seems a rather serious DSDT flaw. Do devices in that slot work in
> Windows?

Yes, the DSDT is pretty broken this way there. Regarding Windows, I
don't know and I doubt anybody will ever try.

regards,
-- 
js
suse labs
