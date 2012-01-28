Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2A1RfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 12:35:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35104 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2A1RfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 12:35:04 -0500
Date: Sat, 28 Jan 2012 21:34:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120128173456.GA1929@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.795551339@openvz.org>
 <20120127181525.GD11715@one.firstfloor.org>
 <20120127182403.GG11086@moon>
 <4F22ED34.4060204@zytor.com>
 <CAKgNAkhYy9b_BqFZ0ycE4ufCHZj6ow3n4kPSOZe+yE5dh67wVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgNAkhYy9b_BqFZ0ycE4ufCHZj6ow3n4kPSOZe+yE5dh67wVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 06:19:41AM +1300, Michael Kerrisk wrote:
> On Sat, Jan 28, 2012 at 7:30 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 01/27/2012 10:24 AM, Cyrill Gorcunov wrote:
> >>
> >> Sure, I'll try to (btw, where I should send it to? And in which
> >> format novadays mans are written? In plain old troff or some
> >> human readable asciidocs?) And... should I post man page
> >> on LKML as well?
> >>
> >
> > Normally they're written using the mandoc macro set in *roff.  Michael
> > Kerrisk (mtk) is the authority on how to do things.
> 
> Cyrill, see  http://www.kernel.org/doc/man-pages/patches.html and the
> following man pages
> man-pages(7)
> man(7)
> groff_man(7)
> 

Hi Michael, thanks! I've found this link yesterday night. Then
I tried to clone man-pages but for some reason it always fail

 | [cyrill@moon projects]$ git clone git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
 | Cloning into 'man-pages'...
 | fatal: The remote end hung up unexpectedly
 | [cyrill@moon projects]$

maybe there another mirror I could fetch this repo?

	Cyrill
