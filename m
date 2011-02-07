Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1BGPEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:04:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41481 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1BGPEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:04:42 -0500
Date: Mon, 7 Feb 2011 16:04:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marc Koschewski <marc@osknowledge.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, mhopf@suse.de, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, nx: Mark the ACPI resume trampoline code
 as +x - fixed
Message-ID: <20110207150428.GA19046@elte.hu>
References: <4D4F8019.2090104@zytor.com>
 <tip-d344e38b2c151ca5e5e39f562017127e93912528@git.kernel.org>
 <20110207145000.GA20671@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207145000.GA20671@marc.osknowledge.org>
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


* Marc Koschewski <marc@osknowledge.org> wrote:

> * tip-bot for H. Peter Anvin <hpa@zytor.com> [2011-02-07 09:24:55 +0000]:
> 
> Great! That one fixes ACPI S3 resume on i7.

Ok, great - i'm sending it to Linus then.

Thanks,

	Ingo
