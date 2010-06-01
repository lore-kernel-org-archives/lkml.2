Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0FAURb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:17:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42674 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0FAURa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=baifxCjY2GQyhOsdQwrjCUjnz7mmnNuZwy4kKhX0/mmySILpPR/JJGQUZ7azppRSMt
         SlJ2e0ytlujvP06qz2hYw8ykhREOlgZMobRLDdX5MDhdaI5nun4EThz0ogCdIUIuQLpB
         BAjzpTJbhkwkRrrH13ANtNaR9+via4R0QVRL0=
Message-ID: <4C056AE6.3000409@gmail.com>
Date: Tue, 01 Jun 2010 13:17:42 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <1275114371-5329-1-git-send-email-justinmattock@gmail.com> <20100531170745.GA21225@srcf.ucam.org> <4C03F5EF.8080302@gmail.com> <20100601190050.GA14667@srcf.ucam.org> <4C055BFF.8090800@gmail.com> <20100601192101.GA15086@srcf.ucam.org> <4C056839.8020605@gmail.com> <20100601200704.GA16091@srcf.ucam.org>
In-Reply-To: <20100601200704.GA16091@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 01:07 PM, Matthew Garrett wrote:
> On Tue, Jun 01, 2010 at 01:06:17PM -0700, Justin P. Mattock wrote:
>
>> nope.. here is what I get:
>> ./reboot
>> Segmentation fault (core dumped)
>
> Sorry, put
>
> iopl(3);
>
> before the outb.
>


still craps out.
this is what the code looks like now:

#include <sys/io.h>

int main() {
	iopl(3);
	outb(6, 0xcf9);
	return 0;
}
(hopefully done right).

as for the acpidump, I seem
to be hitting some error trying
to dissemble it, so I just grabbed my copy from:
https://bugzilla.kernel.org/show_bug.cgi?id=14483

what/where might I be looking for, for this reboot
port in the *.dsl?

Justin P. Mattock
