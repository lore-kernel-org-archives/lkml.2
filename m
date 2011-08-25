Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1HYTww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:52:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35060 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab1HYTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:52:51 -0400
Message-ID: <4E56A7DC.5090805@zytor.com>
Date: Thu, 25 Aug 2011 12:51:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
References: <20110722154219.GA25694@elte.hu> <CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com> <CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com> <CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com> <CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com> <CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com>
In-Reply-To: <CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 12:47 PM, Arnaud Lacombe wrote:
> 
> CPU: Intel QEMU Virtual CPU version 0.14.50 stepping 03
> About to apply_alternatives
> start=c13bee88 a=0 instr_offset=-3922530 instr=cpu_idle+0x26/0x60
> repl_offset=2336 repl=__alt_instructions_end+0x0/0x29f instrlen=5
> repllen=3
>   done

Since this is a QEMU setup, could you share enough of the setup to
reproduce?

	-hpa

