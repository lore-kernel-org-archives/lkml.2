Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2DFVHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:07:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46359 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140Ab2DFVHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:07:19 -0400
Message-ID: <4F7F5AB9.5040309@zytor.com>
Date: Fri, 06 Apr 2012 14:06:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        jmorris@namei.org
Subject: Re: [PATCH v17 08/15] seccomp: add system call filtering using BPF
References: <1333051320-30872-1-git-send-email-wad@chromium.org> <1333051320-30872-9-git-send-email-wad@chromium.org> <20120406132330.457a05cf.akpm@linux-foundation.org> <CAGXu5jJVDLzCOyCo-q6+pF-_3v4Ws8jBzYXwac419uv2QQS0mA@mail.gmail.com> <20120406140503.10b75c5b.akpm@linux-foundation.org>
In-Reply-To: <20120406140503.10b75c5b.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 02:05 PM, Andrew Morton wrote:
>>>
>>> hm, I'm surprised that we don't have a zero-returning implementation of
>>> is_compat_task() when CONFIG_COMPAT=n.  Seems silly.  Blames Arnd.
>>
>> There is
> 
> I can't find it.  The definition in include/linux/compat.h is inside
> #ifdef CONFIG_COMPAT.
> 

I thought Linus globalized it very recently...

	-hpa

