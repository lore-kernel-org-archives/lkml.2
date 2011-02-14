Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1BNLFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:05:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46158 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab1BNLFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:05:43 -0500
Date: Mon, 14 Feb 2011 12:05:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: mingo@readhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        tj@kernel.org, yinghai@kernel.org, ak@linux.intel.com,
        robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: move ioapic_irq_destination_types
Message-ID: <20110214110528.GD7140@elte.hu>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
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


* Henrik Kretzschmar <henne@nachtwindheim.de> wrote:

> +++ b/arch/x86/include/asm/apicdef.h
> @@ -426,4 +426,16 @@ struct local_apic {
>  #else
>   #define BAD_APICID 0xFFFFu
>  #endif
> +
> +enum ioapic_irq_destination_types {
> +	dest_Fixed = 0,
> +	dest_LowestPrio = 1,
> +	dest_SMI = 2,
> +	dest__reserved_1 = 3,
> +	dest_NMI = 4,
> +	dest_INIT = 5,
> +	dest__reserved_2 = 6,
> +	dest_ExtINT = 7
> +};

one very small request, while we are moving it could you please align the value
enumeration vertically? Something like:

enum ioapic_irq_destination_types {

	dest_Fixed		= 0,
	dest_LowestPrio		= 1,
	dest_SMI		= 2,
	dest__reserved_1	= 3,
	dest_NMI		= 4,
	dest_INIT		= 5,
	dest__reserved_2	= 6,
	dest_ExtINT		= 7
};

... would be much more readable, right?

Thanks,

	Ingo
