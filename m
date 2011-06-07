Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1FGG7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:59:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52044 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1FGG7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JWKGyJgNrDN68PNgof5pbq5dQEF3sABS1H/qiyVE1TSB/MqWp1UZjJxxDapw+Z1ABQ
         2amcfyMjUkMnW0A9In/ShcOTi8ZcEBy9Xejt08r2r4jVa+azdr/3aRZMIi9JXooexj9b
         0ckQUfSjPmnAF+ypcr5r1jaKlZz07NZ6LsLsE=
MIME-Version: 1.0
In-Reply-To: <4DED5985.542.14A05486@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu>
	<4DECFE18.23229.133B32ED@pageexec.freemail.hu>
	<20110606164700.GA2391@elte.hu>
	<4DED5985.542.14A05486@pageexec.freemail.hu>
Date: Tue, 7 Jun 2011 09:59:20 +0300
X-Google-Sender-Auth: 2Wy1SQJwxHm70N_JHFSB7aNCSqI
Message-ID: <BANLkTikOWiTJ9zSvtMMT4S27WQW2Fsz_Jw@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
From: Pekka Enberg <penberg@kernel.org>
To: pageexec@freemail.hu
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 1:49 AM,  <pageexec@freemail.hu> wrote:
>> A fastpath is defined by optimization considerations applied to a
>> codepath (the priority it gets compared to other codepaths), *not* by
>> its absolute performance.
>
> we're not talking about random arbitrarily defined paths here but the
> impact of putting well predicted branches into the pf handler vs. int xx
> (are you perhaps confused by 'fast path' vs. 'fastpath'?).

Well, I'm sure confused by 'fast path' vs 'fastpath'! Can you please
explain the difference? Thanks!

                                Pekka
