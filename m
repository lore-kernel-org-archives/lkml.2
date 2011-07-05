Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1GEJdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:33:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1GEJdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:33:54 -0400
Date: Tue, 5 Jul 2011 11:33:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/EFI: properly pre-initialize table pointers
Message-ID: <20110705093343.GB5725@elte.hu>
References: <4E12DC26020000780004C1C1@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E12DC26020000780004C1C1@nat28.tlf.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> Consumers of the table pointers in struct efi check for
> EFI_INVALID_TABLE_ADDR to determine validity, hence these pointers
> should all be pre-initialized to this value (rather than zero).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/platform/efi/efi.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

This changelog is missing some key information:

 - how did you find the bug (by chance via code review or did you see
   some actual badness?)

 - what practical effect (if any) did you see from this patch?

 - what practical effect (if any) do you expect others to see from this patch?

This kind of information helps us prioritize bugfixes.

Thanks,

    Ingo
