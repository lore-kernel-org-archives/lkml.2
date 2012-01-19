Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2ASPoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:44:24 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52146 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2ASPoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:44:22 -0500
Date: Thu, 19 Jan 2012 15:45:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kushal Koolwal <kushalkoolwal@gmail.com>,
        linux-kernel@vger.kernel.org, michael.d.labriola@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
        support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
Message-ID: <20120119154504.710e202e@pyramind.ukuu.org.uk>
In-Reply-To: <OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>
	<20120117195841.48fe8236@pyramind.ukuu.org.uk>
	<OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> checking if reboot_type's value is anything other than BOOT_ACPI (which
> is the default), but that does assume BOOT_ACPI is the default.  What if
> that's ever changed?  Seems likely to me that whoever changes the default
> in the future could very easily re-break this at that point.
> 
> Thoughts?

Fair point - how about a BOOT_DEFAULT define value if it hasn't been set
and we can just make it do the same as ACPI in the switch ?

Alan
