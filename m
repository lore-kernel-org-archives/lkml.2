Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1CaLAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:00:11 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47863 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1CaLAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:00:10 -0400
Date: Thu, 31 Mar 2011 12:59:41 +0200
From: Florian Mickler <florian@mickler.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com,
        zersaa@gmail.com, stable@kernel.org
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics
 are not present
Message-ID: <20110331125941.661a0af9@schatten.dmk.lab>
In-Reply-To: <20110331084342.GA30105@elte.hu>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
	<20110331084342.GA30105@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 10:43:42 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Florian Mickler <florian@mickler.org> wrote:
> 
> > From: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > [I submit this as the corresponding bug report is still not closed, the patch 
> > not merged, distributions applying this patch, it is tested to work and I found
> > nowhere any resoning as to why this should be out of tree. I just guessed on
> > the stable tag and number. -Florian] 
> 
> The patch does not build when CONFIG_ACPI is disabled:
> 
>  arch/x86/kernel/apic/io_apic.c: In function ‘acpi_get_override_irq’:
>  arch/x86/kernel/apic/io_apic.c:3792:6: error: ‘acpi_irq_model’ undeclared (first use in this function)
>  arch/x86/kernel/apic/io_apic.c:3792:24: error: ‘ACPI_IRQ_MODEL_IOAPIC’ undeclared (first use in this function)
> 
> When you or Eric resubmits the fixed patch please use the improved changelog 
> below.
> 
> Thanks,
> 
> 	Ingo

Thank you. Will do if it turns out this is still necessary. 
Paul Bolle mentioned in another messgage that there is a commit in
2.6.38 to the same effect:

commit 678301ecadec24ff77ab310eebf8a32ccddb1850 
("x86, ioapic: Don't warn about non-existing IOAPICs if we have none")

Regards,
Flo
