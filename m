Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0L0NbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 08:31:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57832 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab0L0NbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 08:31:09 -0500
Date: Mon, 27 Dec 2010 14:30:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tigran Aivazian <tigran@bibles.org.uk>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] Intel CPU Microcode Update Driver: Fix double vfree()
 and remove redundant pointer checks before vfree()
Message-ID: <20101227133041.GA13687@elte.hu>
References: <alpine.LNX.2.00.1012251946100.10759@swampdragon.chaosbits.net>
 <AANLkTimPTSwpyj-uNJ9TpDwGjWaodAupr_7VA_Oe1=m4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPTSwpyj-uNJ9TpDwGjWaodAupr_7VA_Oe1=m4@mail.gmail.com>
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


* Tigran Aivazian <tigran@bibles.org.uk> wrote:

> Hi Jesper,
> 
> Your patch looks fine to me.

Thanks - i'll add that as a:

Acked-by: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>

ok?

	Ingo
