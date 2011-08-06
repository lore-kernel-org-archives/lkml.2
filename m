Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab1HFG5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 02:57:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37254 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1HFG5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 02:57:37 -0400
Date: Sat, 6 Aug 2011 08:56:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mgorman@suse.de>
Cc: tglx@linutronix.de, hpa@zytor.com, bruno@ioda-net.ch, mjg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add reboot quirk for Dell Precision M4600
Message-ID: <20110806065635.GE13220@elte.hu>
References: <20110727125651.GH3010@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727125651.GH3010@suse.de>
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


* Mel Gorman <mgorman@suse.de> wrote:

> ACPI reboot does not work for Dell Precision M4600. Detect this
> machine via DMI and force the use of the PCI reboot method.
>     
> Reported-and-tested-by: Bruno Friedmann <bruno@ioda-net.ch>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  arch/x86/kernel/reboot.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)

Weird - ACPI is the default Windows method of reboot - how come it 
does not work on that box? Does Windows work around this specific 
machine (unlikely), or is our ACPI boot sequence not 100% compatible 
with the Windows method (more likely IMO)?

Thanks,

	Ingo
