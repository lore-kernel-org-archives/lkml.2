Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1EQOiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:38:25 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35592 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab1EQOiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:38:24 -0400
Date: Tue, 17 May 2011 16:38:20 +0200
From: Florian Mickler <florian@mickler.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com,
        "# .34+" <stable@kernel.org>
Subject: Re: [PATCH 2/2 v2] x86, ioapic: move acpi_get_override_irq to
 acpi.c
Message-ID: <20110517163820.4b039cfe@schatten.dmk.lab>
In-Reply-To: <20110415101938.GC28007@elte.hu>
References: <20110412215350.50fb5cfa@schatten.dmk.lab>
	<1302638465-1030-1-git-send-email-florian@mickler.org>
	<1302638465-1030-2-git-send-email-florian@mickler.org>
	<20110415101938.GC28007@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 15 Apr 2011 12:19:38 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> >  arch/x86/include/asm/io_apic.h |    8 +++++++-
> >  arch/x86/kernel/apic/io_apic.c |   40 ++++++++++++----------------------------
> >  arch/x86/pci/acpi.c            |   24 ++++++++++++++++++++++++
> >  include/linux/acpi.h           |    6 ++++++
> >  4 files changed, 49 insertions(+), 29 deletions(-)
> 
> Len, is this change fine to you?
> 
> Thanks,
> 
> 	Ingo


sorry if I missed something... what's the status of these 2 patches?

(fixing https://bugzilla.kernel.org/show_bug.cgi?id=17772 )

Regards,
Flo
