Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1HYTti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:49:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56362 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1HYTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com>
References: <20110722154219.GA25694@elte.hu> <CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
 <CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com>
 <CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com>
 <CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com> <CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 25 Aug 2011 15:49:12 -0400
X-Google-Sender-Auth: IgXEnRcW7VSm_tNvkhiMkTp85DI
Message-ID: <CAObL_7FYEYRExGrYKaQtPucCw6PcmUoz0JN-hyCchf01kvaRHA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 3:47 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:

> start=c13bee88 a=10 instr_offset=-1054249774 instr=0x82655bd2
> repl_offset=-1053034552 repl=0x8277e6cc instrlen=5 repllen=5
> BUG: unable to handle kernel paging request at 8277e6cc

This is pretty clearly bogus.  I'll play around with your config.

--Andy
