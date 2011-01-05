Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1AENK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:10:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab1AENK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:10:28 -0500
Date: Wed, 5 Jan 2011 14:10:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86, 64bit: Always make MAX_APICS to 32768
Message-ID: <20110105131020.GB10129@elte.hu>
References: <4D1D2C4D.4090806@kernel.org>
 <20110104084847.GB26209@elte.hu>
 <4D23BD9C.3070102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D23BD9C.3070102@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> > Please fix the real bug first: the lack of boundary checks when we set 
> > phys_cpu_present_map!
>
> real bug is that MAX_APICS and MAX_LOCAL_APIC using is messed up.
> 
> could be MAX_APICS is from 32bit, and MAX_LOCAL_APIC is from 64bit.

Indeed - nice patch!

Thanks,

	Ingo
