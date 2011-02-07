Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1BGHlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:41:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1BGHlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:41:07 -0500
Date: Mon, 7 Feb 2011 08:40:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: castet.matthieu@free.fr, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
Message-ID: <20110207074054.GA21704@elte.hu>
References: <4D473FD5.1090903@free.fr>
 <20110201080223.GB20372@elte.hu>
 <1296566732.4d4809cc1f963@imp.free.fr>
 <20110202062632.GA12256@elte.hu>
 <4D4CA3FD.6000901@zytor.com>
 <1296924395.4d4d7eeb6f1fe@imp.free.fr>
 <4D4F31BC.3000709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4F31BC.3000709@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> The trampoline unification patch could have made this less broken, but
> that code is certainly not ready for .38.
> 
> I'm officially proposing that we mark the low 1 MiB +x for .38, and do
> something saner for .39, including my finishing the trampoline
> unification code.
> 
> Ingo: ok with you?

Sure thing, sounds sane!

Thanks,

	Ingo
