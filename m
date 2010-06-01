Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0FAVMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:12:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47998 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0FAVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:12:29 -0400
Date: Tue, 1 Jun 2010 22:12:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100601211219.GA17719@srcf.ucam.org>
References: <20100601190050.GA14667@srcf.ucam.org> <4C055BFF.8090800@gmail.com> <20100601192101.GA15086@srcf.ucam.org> <4C056839.8020605@gmail.com> <20100601200704.GA16091@srcf.ucam.org> <4C056AE6.3000409@gmail.com> <20100601202130.GA16391@srcf.ucam.org> <4C056E0C.2030709@gmail.com> <20100601203351.GA16575@srcf.ucam.org> <4C0572B4.6000201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0572B4.6000201@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 01:51:00PM -0700, Justin P. Mattock wrote:
> On 06/01/2010 01:33 PM, Matthew Garrett wrote:
>> On Tue, Jun 01, 2010 at 01:31:08PM -0700, Justin P. Mattock wrote:
>> It returns you to the prompt? The machine hangs? What do you mean by
>> "nothing"? (Also, what chipset does this machine have?)
>>
>
> this is what it does:
> It returns you to the prompt

Ok, so it does nothing. Sigh. Thapple.

> as for the chipset name..(not sure)

It's an MCP79. In that case I suspect that we're misdiagnosing this at 
some level. How about the following (again, run as root):

#include <sys/io.h>

int main() {
	iopl(3);
	outb(0xfe, 0x64);
	return 0;
}

-- 
Matthew Garrett | mjg59@srcf.ucam.org
