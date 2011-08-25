Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1HYTvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:51:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37373 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab1HYTvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:51:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7FYEYRExGrYKaQtPucCw6PcmUoz0JN-hyCchf01kvaRHA@mail.gmail.com>
References: <20110722154219.GA25694@elte.hu> <CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
 <CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com>
 <CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com>
 <CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com>
 <CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com> <CAObL_7FYEYRExGrYKaQtPucCw6PcmUoz0JN-hyCchf01kvaRHA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 25 Aug 2011 15:51:33 -0400
X-Google-Sender-Auth: wtTRhJTqD4IAu5e8nUhtlkyvlfQ
Message-ID: <CAObL_7FU2bAbgfuFozrmTDso8HkRWdO0u_9MGm4WP_1t0CCLMQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 3:49 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, Aug 25, 2011 at 3:47 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
>> start=c13bee88 a=10 instr_offset=-1054249774 instr=0x82655bd2
>> repl_offset=-1053034552 repl=0x8277e6cc instrlen=5 repllen=5
>> BUG: unable to handle kernel paging request at 8277e6cc
>
> This is pretty clearly bogus.  I'll play around with your config.

I can reproduce it now.  Hopefully I'll have a patch tomorrow.

--Andy
