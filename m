Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1BNLDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:03:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1BNLDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:03:53 -0500
Date: Mon, 14 Feb 2011 12:03:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: mingo@readhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        tj@kernel.org, yinghai@kernel.org, ak@linux.intel.com,
        robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: ifdef enable_IR_x2apic() out
Message-ID: <20110214110340.GC7140@elte.hu>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
 <1297677612-12405-2-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297677612-12405-2-git-send-email-henne@nachtwindheim.de>
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

> +#ifdef CONFIG_X86_64
>  extern void enable_IR_x2apic(void);
> +#endif

Cannot we use the CONFIG_X86_X2APIC Kconfig switch here, instead of CONFIG_X86_64?

enable_IR_x2apic() is not a 64-bit CPU feature.

Thanks,

	Ingo
