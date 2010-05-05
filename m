Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab0EEI4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:56:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344Ab0EEI4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:56:37 -0400
Date: Wed, 5 May 2010 10:56:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com,
       Yinghai Lu <yinghai@kernel.org>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86, acpi/irq: Handle isa irqs that are not
 identity mapped to gsi's.
Message-ID: <20100505085629.GA16278@elte.hu>
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
 <tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
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


* tip-bot for Eric W. Biederman <ebiederm@xmission.com> wrote:

> Commit-ID:  988856ee1623bd37e384105f7bb2b7fe44c009f6
> Gitweb:     http://git.kernel.org/tip/988856ee1623bd37e384105f7bb2b7fe44c009f6
> Author:     Eric W. Biederman <ebiederm@xmission.com>
> AuthorDate: Tue, 30 Mar 2010 01:07:15 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Tue, 4 May 2010 13:35:17 -0700
> 
> x86, acpi/irq: Handle isa irqs that are not identity mapped to gsi's.

FYI, the patchset causes this build error with certain configs:

arch/x86/kernel/acpi/boot.c:122: error: 'gsi_end' undeclared (first use in this function)
arch/x86/kernel/acpi/boot.c:122: error: (Each undeclared identifier is reported only once
arch/x86/kernel/acpi/boot.c:122: error: for each function it appears in.)
arch/x86/kernel/acpi/boot.c:133: error: 'gsi_end' undeclared (first use in this function)

	Ingo
