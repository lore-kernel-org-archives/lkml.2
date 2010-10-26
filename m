Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0JZHsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:48:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0JZHsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:48:35 -0400
Date: Tue, 26 Oct 2010 09:48:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] arch/x86/kernel/apic/io_apic.c: Typo fix WARNING
Message-ID: <20101026074812.GA9677@elte.hu>
References: <cover.1288059486.git.joe@perches.com>
 <d6f06d6b469fb345ff7738cebae1dc556ed22dbc.1288059486.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6f06d6b469fb345ff7738cebae1dc556ed22dbc.1288059486.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 8ae808d..4640f72 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -4037,7 +4037,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
>  static int bad_ioapic(unsigned long address)
>  {
>  	if (nr_ioapics >= MAX_IO_APICS) {
> -		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
> +		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
>  		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);

While you are touching this please fix the other glaring problem this printk has.

Thanks,

	Ingo
