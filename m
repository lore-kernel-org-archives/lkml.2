Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2LOXqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 18:46:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60809 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2LOXqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 18:46:45 -0500
Message-ID: <50CD0BB8.6000701@zytor.com>
Date: Sat, 15 Dec 2012 15:46:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jan Beulich <jbeulich@suse.com>, Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/uapi for 3.8
References: <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com> <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com> <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com> <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com> <20121215163323.GA229@x4> <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com> <50CCD24F.9090603@zytor.com> <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com> <20121215210411.GA228@x4> <CA+55aFznbC_FHyfGWaD6e6wNE88CiAYaPwjerBh1HfBpfPfNsg@mail.gmail.com> <CAE9FiQX=5=5-U3ix=LGJUOxFrbmYRG3h_qbe11t2Q-zE4pEV3A@mail.gmail.com> <CA+55aFwxtt2Rs7dJt_icCsH5QUzrV_UaATQ3aJQY2KGH+anc3A@mail.gmail.com>
In-Reply-To: <CA+55aFwxtt2Rs7dJt_icCsH5QUzrV_UaATQ3aJQY2KGH+anc3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Anybody see anything else?
>
> And why do we have to call the get-time calls so early? Couldn't we
> move them later and avoid all the crazy "let's create silly magical
> page tables just for the idiotic EFI problems".
>

We need them anyway... actually the whole point of that patch is to try 
to *remove* silly magical page tables just for EFI and use another set 
of silly magical page tables we need anyway (for S3 resume, SMP bootup 
and so on.)  Reducing the sheer number of silly magical page tables has 
been a priority for some time -- I want to get it down to one if we can.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

