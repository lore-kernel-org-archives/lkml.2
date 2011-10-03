Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1JCFfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:35:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49613 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1JCFfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:35:36 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAK1hOcPqVYY93VFbDbMZ39iCr7VH+hP-bQT3u0SPJXmezN7H3Q@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <CAKgNAkicbgpSLZE6Wn_5ickGojJuGd4x2vMUG0491OB+O1Z_HA@mail.gmail.com> <CAK1hOcPqVYY93VFbDbMZ39iCr7VH+hP-bQT3u0SPJXmezN7H3Q@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 3 Oct 2011 07:35:16 +0200
Message-ID: <CAKgNAki5q-w+CkQR8iv35F5yEo6FM+0Z-W1LhhhcGJPMJBki7Q@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Chuck Ebbert <76306.1226@compuserve.com>,
        Blaisorblade <blaisorblade@yahoo.it>,
        Daniel Jacobowitz <dan@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

On Fri, Sep 30, 2011 at 4:28 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Thu, Sep 29, 2011 at 9:08 PM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>> So, I took your patch, and then did a global edit of the page to fix
>> various pieces (in the existing text, as well as do some language
>> clean-ups for the new text). In the process, I found a number of
>> pieces that are still unclear (some in the old text, some in your new
>> text). I also made some changes to your text that I'd like you to
>> check. I've marked each of these with FIXME below. Could you please
>> take a look at the FIXMEs, and write me a comment for each of these.
>> (I appreciate that in some cases, especially for the existing text,
>> you may not have a handy answer Denys, but if you (and others) can
>> give any help, that would be great.)
>>
>> Rather than you writing a new patch to this version of the page, I
>> think it might be easiest if you just replied to the FIXMEs inline
>> below, then I can revise the page in the light of your comments.
>
>       Another group of commands makes the ptrace-stopped  tracee  run.   They
>       have the form:
>
>           ptrace(PTRACE_cmd, pid, 0, sig);
>
>       where  cmd  is  PTRACE_CONT, PTRACE_DETACH, PTRACE_SYSCALL, PTRACE_SIN-
>       GLESTEP, PTRACE_SYSEMU, or PTRACE_SYSEMU_SINGLESTEP.
>
> Cosmetics: cmd is, of course, CONT, DETACH,..., not PTRACE_CONT,
> PTRACE_DETACH...

Yes. But what I did to fix is change the ptrace call to:

      ptrace(cmd, pid, 0, sig);

(Having these constants shown without the "PTRACE_" prefix is a little
confusing.)

>       If the tracee  is
>       in  signal-delivery-stop,  sig  is  the signal to be injected (if it is
>       nonzero).  Otherwise, sig may be ignored.  (Recommended practice is  to
>       always pass 0 in these cases.)
>
> Looks like (my) text in last sentence is confusing. I meant:
> "If you are resterting thracee from a ptrace-stop other than
> signal-delivery-stop, recommended practice is  to always pass
> sig == 0".

Okay -- I made that change.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
