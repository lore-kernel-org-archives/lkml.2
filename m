Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1DDPAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:00:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab1DDPAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:00:50 -0400
Date: Mon, 4 Apr 2011 17:00:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com
Subject: Re: [PATCH] x86, ioapic: move acpi_get_override_irq to acpi.c
Message-ID: <20110404150035.GB11475@elte.hu>
References: <20110401075011.GD7594@elte.hu>
 <1301672686-10096-1-git-send-email-florian@mickler.org>
 <20110401182653.340abaa4@schatten.dmk.lab>
 <20110403163449.33a6a4dc@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403163449.33a6a4dc@schatten.dmk.lab>
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

> On Fri, 1 Apr 2011 18:26:53 +0200
> Florian Mickler <florian@mickler.org> wrote:
> 
> > And how do I check compilation of !CONFIG_X86_IO_APIC?  
> 
> That was a real question, btw. Not just me mumbling around... make
> oldconfig always turns that symbol back on to =y ... and I couldn't find
> out why. 

'make ARCH=i386 allnoconfig' for example.

Thanks,

	Ingo
