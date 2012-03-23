Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2CWW4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:56:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2CWW4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:56:05 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAK1hOcPVYcJan5=fbhz3T0FRZOwGUpFVxfY45r9ST50MqOpk7Q@mail.gmail.com>
References: <CAKgNAkhiHKHSJofXNjCx-NTajzZ5L5Ak_y3YereSJn8dwE=npA@mail.gmail.com>
 <201203170116.11342.vda.linux@googlemail.com> <CAKgNAkjZszURpgoJFevRHcDwXzgjAHaryfjsrb9Gx8d7ttK=SQ@mail.gmail.com>
 <CAK1hOcPVYcJan5=fbhz3T0FRZOwGUpFVxfY45r9ST50MqOpk7Q@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 24 Mar 2012 11:55:43 +1300
Message-ID: <CAKgNAkhcFM66i_RoxB+AV9yViYRVLBfiMDsO=q8wY0spAL=Ubg@mail.gmail.com>
Subject: Re: man-pages-3.37 is released
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 1:51 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> Hi Michael,
>
> On Mon, Mar 19, 2012 at 7:29 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> On Sat, Mar 17, 2012 at 1:16 PM, Denys Vlasenko
>> <vda.linux@googlemail.com> wrote:
>>> On Friday 09 March 2012 18:27, Michael Kerrisk (man-pages) wrote:
>>>> ptrace.2
>>>>     Denys Vlasenko  [Oleg Nesterov, Tejun Heo]
>>>>         add extended description of various ptrace quirks
>>>
>>> Pulled current git and spotted a few broken places.
>>
>> I made a few light edits to your patch, but basically applied it as
>> given for man-pages-3.38.
>
> Thanks! I found one tiny markup bug.
>
> Also, I want to add info about PTRACE_GETEVENTMSG on
> PTRACE_EVENT_EXEC. We document PTRACE_GETEVENTMSG
> on all other PTRACE_EVENT_foo's, except EXEC.
> That's not fair :)
>
> Please find the patch attached.

Thanks Denys. Applied for 3.38. ptrace.2 keeps getting better and better!

I appreciate that you like send the patch as an attachment so it
arrives intact, but it'd be helpful for review if you *also* posted a
copy inline.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
