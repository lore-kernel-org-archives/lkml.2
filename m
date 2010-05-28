Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab0E1UBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0E1UBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:01:05 -0400
Date: Fri, 28 May 2010 21:59:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Henderson <rth@twiddle.net>,
       wezhang@redhat.com, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 0/2] sys_personality fixes v2
Message-ID: <20100528195906.GA15014@redhat.com>
References: <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com> <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com> <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org> <20100528191139.GB12090@redhat.com> <alpine.LFD.2.00.1005281228050.11382@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005281228050.11382@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Linus Torvalds wrote:
>
> Ack to both, and I don't care if the first one gets put down as mine or
> not, it's obviously trivial.
>
> Who wants to merge them? Do I just take them directly, or what?

I meant to ask Andrew to take them, the fix is not urgent.

On the other hand they are very trivial, I just do not know
what will be more convenient to you and Andrew.

Oleg.

