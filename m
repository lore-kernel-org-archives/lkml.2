Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0HUULj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:11:39 -0400
Received: from solo.fdn.fr ([80.67.169.19]:35716 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0HUULg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:11:36 -0400
Date: Sat, 21 Aug 2010 22:10:54 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH,TRIVIAL] Replace Configure with Enable in description of MAXSMP
Message-ID: <20100821201054.GF4760@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Nick Piggin <npiggin@kernel.dk>
References: <20100821193241.GB4760@const.famille.thibault.fr> <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com> <20100821195559.GC4760@const.famille.thibault.fr> <20100821200528.GA27421@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100821200528.GA27421@merkur.ravnborg.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg, le Sat 21 Aug 2010 22:05:28 +0200, a écrit :
> The canonical patch subject line is:
> 
>     Subject: [PATCH 001/123] subsystem: summary phrase
> 
>   - The body of the explanation, which will be copied to the
>     permanent changelog to describe this patch.
> 
> That should do it. We cannot tell what should NOT be done.

Yes, but according to what is above, we need to repeat the subject,
else it won't be in the changelog.  Actually, this is probably where it
should be said 'do not repeat the subject, it will already be included'.

> If you use git then it is trivial to commit your changes and
> generate patches using "git format-patch ..."

That's just one case. See above for the general case.

Samuel
