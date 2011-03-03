Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1CCJPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:15:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45178 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176Ab1CCJO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:14:58 -0500
Date: Thu, 3 Mar 2011 10:14:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, amd-nb: Misc correctness fixes
Message-ID: <20110303091440.GA18252@elte.hu>
References: <20110302193855.GA3840@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302193855.GA3840@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> Make functions used strictly in bool context return bool. Also, fixup
> used types and comments, and make a local function static, while at it.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

I'm confused about the title - a 'correctness fix' is one that fixes an actual bug.

Did you mean 'cleanliness fixes'?

Also, checkpatch outputs a warning that looks legit.

Thanks,

	Ingo
