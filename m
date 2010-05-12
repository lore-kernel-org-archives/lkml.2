Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0ELAmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:42:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab0ELAmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:42:38 -0400
Date: Tue, 11 May 2010 17:39:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
In-Reply-To: <20100511191807.GA12035@elte.hu>
Message-ID: <alpine.LFD.2.00.1005111738460.3711@i5.linux-foundation.org>
References: <20100511191807.GA12035@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 May 2010, Ingo Molnar wrote:
>
> Frederic Weisbecker (1):
>       perf: Fix static strings treated like dynamic ones

Grr. This one doesn't have a proper sign-off chain.

I pulled it, but please be more careful.

		Linus
