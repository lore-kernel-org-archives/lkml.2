Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1DOKTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:19:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45047 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1DOKTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:19:52 -0400
Date: Fri, 15 Apr 2011 12:19:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Florian Mickler <florian@mickler.org>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com,
        "# .34+" <stable@kernel.org>
Subject: Re: [PATCH 2/2 v2] x86, ioapic: move acpi_get_override_irq to acpi.c
Message-ID: <20110415101938.GC28007@elte.hu>
References: <20110412215350.50fb5cfa@schatten.dmk.lab>
 <1302638465-1030-1-git-send-email-florian@mickler.org>
 <1302638465-1030-2-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302638465-1030-2-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Florian Mickler <florian@mickler.org> wrote:

> In order to get rid of the ugly CONFIG_ACPI ifdef, we move
> the function acpi_get_override_irq into acpi.c and add a new
> helper function ioapic_get_irq to io_apic.c.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: kurup_avinash@yahoo.com
> Cc: maciej.rutecki@gmail.com
> Cc: rjw@sisk.pl
> Cc: sedat.dilek@gmail.com
> Cc: # .34+ <stable@kernel.org>
> LKML-Reference: <1301558489-4198-1-git-send-email-florian@mickler.org>
> ---
> [v2: removed the acpi_get_override_irq macro in acpi.h] 
> 
> 
>  arch/x86/include/asm/io_apic.h |    8 +++++++-
>  arch/x86/kernel/apic/io_apic.c |   40 ++++++++++++----------------------------
>  arch/x86/pci/acpi.c            |   24 ++++++++++++++++++++++++
>  include/linux/acpi.h           |    6 ++++++
>  4 files changed, 49 insertions(+), 29 deletions(-)

Len, is this change fine to you?

Thanks,

	Ingo
