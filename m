Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1BTNC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:02:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1BTNC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:02:27 -0500
Date: Sun, 20 Feb 2011 14:02:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Carpenter <error27@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] x86, microcode, AMD: signedness bug in
 generic_load_microcode()
Message-ID: <20110220130214.GD25700@elte.hu>
References: <20110218091716.GA4384@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218091716.GA4384@bicker>
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


* Dan Carpenter <error27@gmail.com> wrote:

> install_equiv_cpu_table() returns type int.  It uses negative error
> codes so using an unsigned type breaks the error handling.

How did you notice this btw - did GCC throw a warning?

Thanks,

	Ingo
