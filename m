Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1CEI3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:29:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1CEI3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:29:33 -0500
Date: Sat, 5 Mar 2011 09:29:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: Remove dead config option X86_CPU
Message-ID: <20110305082918.GA32531@elte.hu>
References: <4D710BFC0200007800034F3A@vpn.id2.novell.com>
 <tip-24a2a35a18ebc4e143e86ad3fda50ee78de30d06@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-24a2a35a18ebc4e143e86ad3fda50ee78de30d06@git.kernel.org>
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


* tip-bot for Jan Beulich <JBeulich@novell.com> wrote:

> Commit-ID:  24a2a35a18ebc4e143e86ad3fda50ee78de30d06
> Gitweb:     http://git.kernel.org/tip/24a2a35a18ebc4e143e86ad3fda50ee78de30d06
> Author:     Jan Beulich <JBeulich@novell.com>
> AuthorDate: Fri, 4 Mar 2011 14:57:48 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 4 Mar 2011 16:34:33 +0100
> 
> x86: Remove dead config option X86_CPU
> 
> This isn't being referenced anywhere, and the selects done from
> it can be easily done together with all the other X86 ones

This broke UML ...

mm/built-in.o: In function `vm_unmap_aliases':
/home/mingo/tip/mm/vmalloc.c:989: undefined reference to `find_next_bit'
/home/mingo/tip/mm/vmalloc.c:993: undefined reference to `find_next_zero_bit'
/home/mingo/tip/mm/vmalloc.c:1006: undefined reference to `find_next_bit'

Thanks,

	Ingo
