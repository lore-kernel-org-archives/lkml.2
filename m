Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1JYVGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 17:06:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59543 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1JYVGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 17:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdURkdEeCELptisYT4FP5hTBwxBogA4oiZoS+rR2DoDpfw@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
 <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
 <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
 <CAFkjPTkbEbDp9pOg0mOrCh4BdR0SUrVj_7aJ1yfEsqRjQQcqeQ@mail.gmail.com> <CAMuHMdURkdEeCELptisYT4FP5hTBwxBogA4oiZoS+rR2DoDpfw@mail.gmail.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Tue, 25 Oct 2011 16:05:46 -0500
Message-ID: <CAFkjPTnqpw-WF+37Hcr6-vzdTwoWoMw3E42OmuW6MA5G294J2Q@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 3:46 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Oct 25, 2011 at 22:23, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>> On Tue, Oct 25, 2011 at 3:14 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>> On Tue, Oct 25, 2011 at 2:25 AM, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> On Mon, Oct 24, 2011 at 6:28 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>>>
>>>> (Also, I'm only seeing about half the patches mentioned in linux-next. Hmm?)
>>>
>>
>> okay, which linux-next tree are you looking at (and/or which patches
>> are they missing)? If I look at
>> /pub/scm/linux/kernel/git/next/linux-next.git on kernel.org I see all
>> the patches mentioned in my pull.  Sorry in advance if I'm doing
>> something stupid.
>
> Current linux-next is next-20111025, but the previous one was next-20111014.
>

I think I see the requested changes in both of those versions:
   == next-20111025 ==
14211d0 9p: fix 9p.txt to advertise msize instead of maxdata
348b590 net/9p: Convert net/9p protocol dumps to tracepoints
ef6b080 fs/9p: change an int to unsigned int
4d5077f fs/9p: Cleanup option parsing in 9p
5635fd0 9p: move dereference after NULL check
464f5ec fs/9p: inode file operation is properly initialized init_special_inode
abfa034 fs/9p: Update zero-copy implementation in 9p
  == next-20111014 ==
662db18 9p: fix 9p.txt to advertise msize instead of maxdata
ebbfa91 net/9p: Convert net/9p protocol dumps to tracepoints
0c2f0c5 fs/9p: change an int to unsigned int
73bd290 fs/9p: Cleanup option parsing in 9p
99f4122 9p: move dereference after NULL check
402e032 fs/9p: inode file operation is properly initialized init_special_inode
6851475 fs/9p: Update zero-copy implementation in 9p

The ordering was a bit wacky in next-20111014, like stuff had been
shuffled around, but they were all there.

             -eric
