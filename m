Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab2CIUNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:13:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33273 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116Ab2CIUNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:13:36 -0500
Message-ID: <4F5A644C.3080306@zytor.com>
Date: Fri, 09 Mar 2012 12:13:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
References: <20120309074202.GA28609@www.outflux.net> <20120309092845.GA10281@elte.hu> <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com> <4F5A448D.70605@zytor.com> <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com> <20120309182829.GA13745@aftab> <CAGXu5jJaO29hqMfACav9v8yEdHXt-SegozGuc+tigYCF6K57WA@mail.gmail.com> <20120309190842.GC13745@aftab>
In-Reply-To: <20120309190842.GC13745@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 11:08 AM, Borislav Petkov wrote:
> 
> So is this reserved or are we using it for Spurious IRQs? If we use it,
> then 'RES' is a bad name. Maybe we define our own like
> 
> X86_VEC_SP
> 
> and then do
> 
> X86_VEC_IR for IRET
> 
> in the manner we assumed for the rest?
> 

Actually I prefer if we didn't use two-letter versions for the ones that
aren't defined in the documentation; especially IRET which is a pure
Linux invention.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

