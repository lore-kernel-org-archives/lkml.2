Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1E0RMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:12:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37226 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab1E0RMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:12:45 -0400
Date: Fri, 27 May 2011 19:12:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, asm: Clean up desc.h a bit
Message-ID: <20110527171240.GD4356@elte.hu>
References: <tip-incpt6y26yd8586idx65t9ll@git.kernel.org>
 <4DDFD958.9090700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDFD958.9090700@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/27/2011 01:39 AM, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  9a3865b185e77d1a4ca2d8356e37c19b78168961
> > Gitweb:     http://git.kernel.org/tip/9a3865b185e77d1a4ca2d8356e37c19b78168961
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Fri, 27 May 2011 09:29:32 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 27 May 2011 09:30:50 +0200
> > 
> > x86, asm: Clean up desc.h a bit
> > 
> > I have looked at this file and found it rather ugly - improve
> > readability a bit. No change in functionality.
> > 
> 
> It sure is, but let me also register for the record that I hate the
> bloody bitfield.  A lot of what the bitfield does is completely
> pointless (breaking down the type field, which really is nothing other
> than a magic constant as far as the kernel is anyway) and generates
> insanely bad code.
> 
> I honestly think if we used macros like GDT_ENTRY() and perhaps a few
> variants we would make the code simpler.

Yeah. I really didnt want to modify functionality in this patch, just 
wanted my eyes to not bleed. Using macros there would probably 
generate better code as well, right?

Thanks,

	Ingo
