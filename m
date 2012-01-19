Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2ASPtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:49:11 -0500
Received: from mx2.gd-ms.com ([153.11.250.41]:48537 "EHLO mx2.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab2ASPtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:49:08 -0500
In-Reply-To: <20120119154504.710e202e@pyramind.ukuu.org.uk>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>	<20120117195841.48fe8236@pyramind.ukuu.org.uk>
	<OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com> <20120119154504.710e202e@pyramind.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kushal Koolwal <kushalkoolwal@gmail.com>,
        linux-kernel@vger.kernel.org, michael.d.labriola@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
        support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
X-KeepSent: 8642E997:5ED041E1-8525798A:0056983A;
 type=4; name=$KeepSent
Message-ID: <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Thu, 19 Jan 2012 10:48:53 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-MESSAGE-ID: X-GDM-MESSAGE-ID mx2.gd-ms.com 1RnuET-0004y5-CZ
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 01/19/2012 10:45:04 AM:

> > checking if reboot_type's value is anything other than BOOT_ACPI 
(which
> > is the default), but that does assume BOOT_ACPI is the default.  What 
if
> > that's ever changed?  Seems likely to me that whoever changes the 
default
> > in the future could very easily re-break this at that point.
> > 
> > Thoughts?
> 
> Fair point - how about a BOOT_DEFAULT define value if it hasn't been set
> and we can just make it do the same as ACPI in the switch ?

Sounds good to me.  I'll whip that up and resubmit.

---
Michael D Labriola
Electric Boat
mlabriol@gdeb.com
401-848-8871 (desk)
401-848-8513 (lab)
401-316-9844 (cell)




 

