Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab1JCSlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:41:15 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:47864 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab1JCSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:41:06 -0400
Date: Mon, 3 Oct 2011 21:41:04 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.1 patch] x86: default to vsyscall=native
Message-ID: <20111003184104.GA2996@localhost.pp.htv.fi>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
 <CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
 <20111003173359.GA3072@localhost.pp.htv.fi>
 <CAObL_7F2=L+0wpFg7c-TL9FzvPos5kFM5=KPMvzeHuTaG5sysQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7F2=L+0wpFg7c-TL9FzvPos5kFM5=KPMvzeHuTaG5sysQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 11:06:13AM -0700, Andrew Lutomirski wrote:
> On Mon, Oct 3, 2011 at 10:33 AM, Adrian Bunk <bunk@stusta.de> wrote:
> > On Mon, Oct 03, 2011 at 06:04:53AM -0700, Andrew Lutomirski wrote:
>...
> >> of a bug in that the new code doesn't report si_addr properly, but
> >> that sounds unlikely as a culprit.  Did you try with the offending
> >> commit reverted (i.e. fce8dc0)?  I bet that it also fails there.
> >
> > fce8dc0 is "x86-64: Wire up getcpu syscall", is that really the one you
> > want me to revert?
> 
> No -- I actually meant to try running that revision or to try with the
> vsyscall= patch reverted.

I now tried both, and your bet was right.

>...
> --Andy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

