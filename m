Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2AXHFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 02:05:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57363 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab2AXHFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 02:05:08 -0500
Message-ID: <4F1E57F3.6020607@zytor.com>
Date: Mon, 23 Jan 2012 23:04:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
References: <20120123142036.025893883@openvz.org> <20120123142436.258631438@openvz.org> <20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com> <20120124064719.GA29735@moon>
In-Reply-To: <20120124064719.GA29735@moon>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 10:47 PM, Cyrill Gorcunov wrote:
>>
>> Why under /arch ?
>>
> 
> Hi Kame,
> 
> because I've tested it under x86 only. Once someone
> confirm it's needed on some else arch and does work
> as expected -- it wont be a problem to make it system
> wide. Until then -- I think better to stick with
> at least tested case.
> ...

That's not a reason to put it in arch/ ... that's possibly a reason to
not map the system call on other architectures yet.

	-hpa
