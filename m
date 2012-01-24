Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2AXWxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:53:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33003 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2AXWxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:53:15 -0500
Message-ID: <4F1F3630.4010404@zytor.com>
Date: Tue, 24 Jan 2012 14:52:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
References: <20120124064719.GA29735@moon> <4F1E57F3.6020607@zytor.com> <20120124071716.GC29735@moon> <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com> <20120124073842.GE29735@moon> <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com> <20120124084823.GF29735@moon> <CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com> <20120124202606.GC2546@moon> <m18vkwj0dw.fsf@fess.ebiederm.org> <20120124205039.GB2278@moon> <20120124132222.d78bc0d4.akpm@linux-foundation.org> <20120124134510.75f2c63f.akpm@linux-foundation.org> <4F1F26B7.2010209@zytor.com> <20120124140011.60b6488c.akpm@linux-foundation.org>
In-Reply-To: <20120124140011.60b6488c.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 02:00 PM, Andrew Morton wrote:
>>
>> Arithmetic on void pointers?
> 
> All the world is gcc!

Even so, warnings are annoying...

	-hpa
