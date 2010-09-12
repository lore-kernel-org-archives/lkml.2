Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0ILUbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:31:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52744 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab0ILUbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:31:08 -0400
Date: Sun, 12 Sep 2010 22:29:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Feng Tang <feng.tang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, zersaa <zersaa@gmail.com>
Subject: Re: [Bug #17772] Unable to locate IOAPIC for GSI *
Message-ID: <20100912202950.GA16751@elte.hu>
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
 <p44oKaOqEDM.A.I2E.VgSjMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p44oKaOqEDM.A.I2E.VgSjMB@chimera>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17772
> Subject		: Unable to locate IOAPIC for GSI *
> Submitter	: zersaa <zersaa@gmail.com>
> Date		: 2010-09-04 21:28 (9 days old)

this is an error message introduced via ACPI commit:

| commit 2a4ab640d3c28c2952967e5f63ea495555bf2a5f
| Author: Feng Tang <feng.tang@intel.com>
| Date:   Tue Jul 7 23:01:15 2009 -0400
|
|     ACPI, x86: expose some IO-APIC routines when CONFIG_ACPI=n

It's not clear from the bugzilla entry whether it's just a new error 
message, or an actual boot failure. It appears to me it's just a new 
message - i.e. not a regression.

Thanks,

	Ingo
