Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0E1Tcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:32:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541Ab0E1Tct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:32:49 -0400
Date: Fri, 28 May 2010 12:28:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Henderson <rth@twiddle.net>,
       wezhang@redhat.com, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 0/2] sys_personality fixes v2
In-Reply-To: <20100528191139.GB12090@redhat.com>
Message-ID: <alpine.LFD.2.00.1005281228050.11382@i5.linux-foundation.org>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com>
 <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com> <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org> <20100528191139.GB12090@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 May 2010, Oleg Nesterov wrote:
> 
> I am just resending Linus's patch + another one with the minor cleanup.
> 
> 1/2 lacks the "From: Linus" tag, but this is only because I'm afraid he
> won't be proud by the changelog I wrote.

Ack to both, and I don't care if the first one gets put down as mine or 
not, it's obviously trivial.

Who wants to merge them? Do I just take them directly, or what?

			Linus
