Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2BCKRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:17:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47794 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357Ab2BCKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:17:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120203100743.GA3334@elte.hu>
References: <20120130140905.441199885@openvz.org>
	<20120130141852.309402052@openvz.org>
	<20120203074656.GC30543@elte.hu>
	<20120203083530.GD1968@moon>
	<20120203090929.GA23996@elte.hu>
	<20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	<20120203095227.GA13162@elte.hu>
	<20120203100743.GA3334@elte.hu>
Date: Fri, 3 Feb 2012 12:17:43 +0200
X-Google-Sender-Auth: uiOO9OVtd0WFMhgqUPwNTh1PsiY
Message-ID: <CAOJsxLE1cjwBic++fY2auSk2wdfsPDfKm750pvoYmE_rF4972g@mail.gmail.com>
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from 80
 to 100 colums
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 12:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> The kernel has *already* become a gruesome mess for 80 col
>> users long ago. That was the main reason why I stopped using
>> 80 col terminals two years ago ...
>>
>> So lets stop the pretense.
>
> in other words:
>
> --------------->
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
>
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
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

The rationale in the changelog is somewhat over the top but I agree
with the change :-)

Acked-by: Pekka Enberg <penberg@kernel.org>
