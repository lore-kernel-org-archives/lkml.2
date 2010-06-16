Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0FPJLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:11:42 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:47374 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0FPJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:11:40 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 05:11:39 EDT
Date: Wed, 16 Jun 2010 11:01:55 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Eric Dumazet <eric.dumazet@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
Message-ID: <20100616090155.GK4240@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Arjan van de Ven <arjan@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1276441427-31514-1-git-send-email-avi@redhat.com> <4C187C22.2080505@redhat.com> <4C187DF1.9030007@zytor.com> <4C188527.9040305@redhat.com> <20100616083941.GA27151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100616083941.GA27151@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar, le Wed 16 Jun 2010 10:39:41 +0200, a écrit :
> in the long run most processes will be using the FPU due to SIMM      
> instructions.

I believe glibc already uses SIMM instructions for e.g. memcpy and
friends, i.e. basically all applications...

Samuel
