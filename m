Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2CIWX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:23:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34114 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab2CIWXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:23:55 -0500
Message-ID: <4F5A82CD.2040208@zytor.com>
Date: Fri, 09 Mar 2012 14:23:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@amd64.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
References: <20120309074202.GA28609@www.outflux.net> <20120309092845.GA10281@elte.hu> <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com> <4F5A448D.70605@zytor.com> <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com> <20120309182829.GA13745@aftab> <1331319124.25686.580.camel@gandalf.stny.rr.com> <4F5A63B3.1040509@zytor.com> <20120309221302.GA17158@elte.hu>
In-Reply-To: <20120309221302.GA17158@elte.hu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 02:13 PM, Ingo Molnar wrote:
> 
> Make it X86_TRAP_XX, it's both short and correct?
> 

Works for me.

	-hpa

