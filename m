Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1LLDIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:08:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1LLDIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:08:42 -0500
Date: Mon, 12 Dec 2011 04:06:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
Message-ID: <20111212030654.GA3201@elte.hu>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323648762-2148-1-git-send-email-keithp@keithp.com>
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


* Keith Packard <keithp@keithp.com> wrote:

> This hangs my MacBook Air at boot time; I get no console messages at
> all. I reverted this on top of -rc5 and my machine boots again.
> 
> This reverts commit e8c7106280a305e1ff2a3a8a4dfce141469fb039.
> 
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Huang Ying <huang.ying.caritas@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Link: http://lkml.kernel.org/r/1321621751-3650-1-git-send-email-matt@console
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Keith Packard <keithp@keithp.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
