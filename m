Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1DLHjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:39:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1DLHjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:39:39 -0400
Date: Tue, 12 Apr 2011 09:39:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com
Subject: Re: [PATCH] x86, ioapic: move acpi_get_override_irq to acpi.c
Message-ID: <20110412073929.GA26892@elte.hu>
References: <20110401075011.GD7594@elte.hu>
 <1301672686-10096-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301672686-10096-1-git-send-email-florian@mickler.org>
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
> LKML-Reference: <1301558489-4198-1-git-send-email-florian@mickler.org>
> ---
> 
> Hi Ingo,
> 
> Instead of exporting find_irq_entry, irq_trigger and irq_polarity, I added a 
> new helper function 'ioapic_get_irq(..)' and exported that. 
> 
> Also I did it as a seperate commit, since it is more of a cleanup and the other 
> commit is already tested... hope this is ok. 

Yeah, looks good in principle.

Mind porting to the latest x86 devel tree and resend the patch? I tried to 
apply your patch but there's a conflict. You can find the tree at:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
