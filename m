Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0DGOF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:05:56 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:57857 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab0DGOFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:05:53 -0400
Message-ID: <4BBC913E.5050703@grupopie.com>
Date: Wed, 07 Apr 2010 15:05:50 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org> <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org> <20100406205123.GC20357@a1.tnic> <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org> <20100406225925.GA3446@liondog.tnic> <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> [...]
> So it once more is 'anon_vma->head.next' that is crap, but now it's not 
> NULL, it's that very odd 0x002e2e2e002e2e2e pattern (the %r13 has had 0x20 
> subtracted from it, so that LSB of "0x0e" is actually _also_ a 0x2e).
> 
> What does '0x2e' mean? It's ASCII '.', but that doesn't really mean 
> anything either.

Just a wild shot in the dark: it can be a couple of gray pixels with
intensity 0x2e at some 32 bits per pixel mode. I say this because of the
zero bytes there and someone mentioning seeing the problem when starting X.

-- 
Paulo Marques - www.grupopie.com

"Don't worry, you'll be fine; I saw it work in a cartoon once..."
