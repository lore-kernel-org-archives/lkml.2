Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab1JRGlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:41:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1JRGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:41:44 -0400
Date: Tue, 18 Oct 2011 08:40:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Conny Seidel <conny.seidel@amd.com>
Cc: Jan Beulich <JBeulich@suse.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] i386/bigsmp: eliminate false warnings regarding
 logical APIC ID mismatches
Message-ID: <20111018064002.GK16304@elte.hu>
References: <4E835D16020000780005844C@nat28.tlf.novell.com>
 <20111016232330.57d7facf.conny.seidel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111016232330.57d7facf.conny.seidel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Conny Seidel <conny.seidel@amd.com> wrote:

> @@ -200,14 +200,8 @@ void __init default_setup_apic_routing(v
>  	 * - we find more than 8 CPUs in acpi LAPIC listing with
>  xAPIC support */
> 
> -	if (!cmdline_apic && apic == &apic_default) {
> -		struct apic *bigsmp = generic_bigsmp_probe();
> -		if (bigsmp) {
> -			apic = bigsmp;
> -			printk(KERN_INFO "Overriding APIC driver with
> %s\n",

This inlined patch got hurt via linewraps in unexpected places - 
please see Documentation/email-clients.txt.

Thanks,

	Ingo
