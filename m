Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab1BJMSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:18:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab1BJMSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:18:44 -0500
Date: Thu, 10 Feb 2011 13:18:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Ingo Molnar <mingo@redhead.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: fused  X86_UP_APIC and  X86_UP_IOAPIC ?
Message-ID: <20110210121835.GB26094@elte.hu>
References: <4D53BF67.50601@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D53BF67.50601@nachtwindheim.de>
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

> Hi there,
> 
> In commit 7cd92366a593246650cc7d6198e2c7d3af8c1d8a (x86/Voyager: remove 
> APIC/IO-APIC Kbuild quirk / just before 2.6.29-rc4) Ingo replaced the 
> X86_UP_IOAPIC with X86_UP_APIC.
> 
> Was this intended or by accident?

Looks accidental. Wondering why it didn't cause problems. Mind sending a patch 
against the latest x86 tree:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
