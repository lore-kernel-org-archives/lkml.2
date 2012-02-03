Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2BCQOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:14:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52019 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2BCQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:14:05 -0500
Date: Fri, 3 Feb 2012 08:13:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from
 80 to 100 colums
Message-ID: <20120203161358.GA805@google.com>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu>
 <20120203100743.GA3334@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203100743.GA3334@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 03, 2012 at 11:07:43AM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > If we want to increase the standard to (say) 96 cols then 
> > > fine, I'd be happy with that.  But until we do that we 
> > > should not create such a gruesome mess for those who use 80 
> > > cols.
> > 
> > The kernel has *already* become a gruesome mess for 80 col 
> > users long ago. That was the main reason why I stopped using 
> > 80 col terminals two years ago ...
> > 
> > So lets stop the pretense.

I don't know.  In my experience, a lot of code, especially core part,
mostly follows 80 col limit.  It shouldn't be too difficult to write
up a script to count >80col lines in different parts of the kernel.

> [PATCH] SubmittingPatches: Increase the line length limit from 80 to 100 colums
> 
> The overwhelming majority of kernel developers have stopped 
> using 80 col terminals years ago.
> 
> As far as I'm aware I was the last regular kernel contributor 
> who still used a standard VGA text console, but both text 
> consoles and using them to read the kernel source code has 
> become increasingly gruesome years ago so I switched to a wider 
> terminal two years ago.

People usually place multiple windows horizontally so it's not like
all those extra pixels go wasted.  80col might even have the benefit
of giving overall higher density in terms of pixel usage.

> Worse than that, people are actively uglifying the kernel code 
> to fit things into 80 cols mechanically. They are using 
> checkpatch and are interpreting the 80 col warnings the wrong 
> way again and again, sucking up reviewer bandwidth that could be 
> utilized better.
> 
> So lets increase the limit to 100 cols - this is a nice round 
> limit, and it also happens to match with most developer xterm 
> sizes. Code that goes over 100 cols for no good reasons will be 
> arguably something worth fixing. (100 cols is also arguably 
> closer to various brain limits such as vision of field and 
> resolution restrictions, so we'll likely not have to increase 
> this limit for a couple of million years, for all retro human 
> genome users.)

That said, yeah, 80col is a pain in the ass and lessening the pressure
a bit might make it a non-problem and 100 is one of the nicer numbers
which aren't power of two.

For me, the biggest reason to stick to 80col has been that, while
being widely disliked, it still was the most common limit people were
using and consistency tends to be more beneficial on these issues.  If
we're gonna do this, and I hope we do, let's proactively encourage /
enforce it - ie. let's collectively nag so that 100col quickly becomes
the standard.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
