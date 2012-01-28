Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2A1RUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 12:20:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46871 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2A1RUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 12:20:02 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <4F22ED34.4060204@zytor.com>
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org>
 <20120127181525.GD11715@one.firstfloor.org> <20120127182403.GG11086@moon> <4F22ED34.4060204@zytor.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 29 Jan 2012 06:19:41 +1300
Message-ID: <CAKgNAkhYy9b_BqFZ0ycE4ufCHZj6ow3n4kPSOZe+yE5dh67wVA@mail.gmail.com>
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
To: "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 7:30 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/27/2012 10:24 AM, Cyrill Gorcunov wrote:
>>
>> Sure, I'll try to (btw, where I should send it to? And in which
>> format novadays mans are written? In plain old troff or some
>> human readable asciidocs?) And... should I post man page
>> on LKML as well?
>>
>
> Normally they're written using the mandoc macro set in *roff.  Michael
> Kerrisk (mtk) is the authority on how to do things.

Cyrill, see  http://www.kernel.org/doc/man-pages/patches.html and the
following man pages
man-pages(7)
man(7)
groff_man(7)

Thanks,

Michael
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
