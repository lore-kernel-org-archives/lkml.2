Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1EXSoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:44:55 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:38221 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab1EXSow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:44:52 -0400
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 14:44:52 EDT
Date: Tue, 24 May 2011 20:34:05 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: (Short?) merge window reminder
Message-ID: <20110524183405.GA14493@citd.de>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
 <20110523192056.GC23629@elte.hu>
 <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.2011 13:33, Linus Torvalds wrote:
> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > I really hope there's also a voice that tells you to wait until .42 before
> > cutting 3.0.0! :-)
> 
> So I'm toying with 3.0 (and in that case, it really would be "3.0",
> not "3.0.0" - the stable team would get the third digit rather than
> the fourth one.

What about strictly 3 part versions? Just add a .0.

3.0.0 - Release Kernel 3.0
3.0.1 - Stable 1
3.0.2 - Stable 2
3.1.0 - Release Kernel 3.1
3.1.1 - Stable 1
...

Biggest problem is likely version phobics that get pimples when they see 
trailing zeros. ;-)




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

