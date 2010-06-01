Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab0FAV3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:29:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41498 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab0FAV3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:29:11 -0400
Date: Tue, 1 Jun 2010 22:29:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100601212901.GA18390@srcf.ucam.org>
References: <20100601192101.GA15086@srcf.ucam.org> <4C056839.8020605@gmail.com> <20100601200704.GA16091@srcf.ucam.org> <4C056AE6.3000409@gmail.com> <20100601202130.GA16391@srcf.ucam.org> <4C056E0C.2030709@gmail.com> <20100601203351.GA16575@srcf.ucam.org> <4C0572B4.6000201@gmail.com> <20100601211219.GA17719@srcf.ucam.org> <4C057AE9.9020307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C057AE9.9020307@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 02:26:01PM -0700, Justin P. Mattock wrote:
> On 06/01/2010 02:12 PM, Matthew Garrett wrote:
>> some level. How about the following (again, run as root):
>>
>> #include<sys/io.h>
>>
>> int main() {
>> 	iopl(3);
>> 	outb(0xfe, 0x64);
>> 	return 0;
>> }
>>

So, just to be clear, you run this as root and it immediately returns 
you to the prompt? This seems unlikely.

> ahh!! I see now:
> grep 0x64 *.dsl

No, that's unrelated.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
