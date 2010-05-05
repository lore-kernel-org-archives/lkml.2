Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab0EEI6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:58:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33557 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344Ab0EEI6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:58:36 -0400
Date: Wed, 5 May 2010 10:58:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai <yinghai.lu@oracle.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86 acpi/irq: Fix harmless typo.
Message-ID: <20100505085802.GB16278@elte.hu>
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
 <tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
 <4BE12323.2010104@oracle.com>
 <m1mxwe7ms0.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mxwe7ms0.fsf_-_@fess.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> YH noticed that the function irq_to_gsi has an off by one error
> when translating high irq numbers to gsis.  Today this bug is harmless
> because all of the callers restrict their input to the first 16 irqs
> so this bug does not matter, but we should fix it to avoid confusion
> and later.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Please use the Reported-by tag.

Thanks,

	Ingo
