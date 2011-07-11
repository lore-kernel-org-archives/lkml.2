Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab1GKWz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:55:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39943 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327Ab1GKWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:55:56 -0400
Date: Mon, 11 Jul 2011 17:55:48 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>,
        Daniel Manrique <daniel.manrique@canonical.com>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m2wrfofpro.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107111749370.14531@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <1310419715-13254-2-git-send-email-manoj.iyer@canonical.com> <m2wrfofpro.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +		dev_notice(&dev->dev, "Controller base frequency changed to 50Mhz)\n");
>
> There's an erroneous ")" in this string; I'll replace it with a "." if
> this patch goes in via my tree.  Also, let's make it "MMC controller"
> instead of just "Controller".

Oops, I can fix that and resend, or would you rather make the change 
while (if) applying to your tree?

>
>> +	}
>> +
>>  }
>>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>>  DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>
> Have you checked to see how SD I/O performance differs after this change?
>
> (If this is significant, perhaps we want to try lowering the frequency
> only after a card starts returning errors, since some cards work fine
> at the higher frequency.)
>

This is something I thought about too, I can try and get some data on the 
cards (that already works) with the patch applied. Do you have any 
specific benchmarks in mind that you would like me to run? Or will timing 
read and write will work?

Thanks a ton!
--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
