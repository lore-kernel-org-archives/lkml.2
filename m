Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1FHFz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:55:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38616 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1FHFz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=p5v6NUzm8M8DNdMlfRyZMnveKO4duHE3p9Qgh0YuiyvKJCeyxLw6zSFt5hitLPQ3dw
         8QH+NNMYnd2bnpv0f0JoDBcdaeSQ/UsBNmCUsS7srQXW9p700dfF932ZcQ3fuho1JxHG
         jdTlmo1HHR8eNsmC456KBUFp7q99fatCLxlzE=
MIME-Version: 1.0
In-Reply-To: <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu>
	<4DED5985.542.14A05486@pageexec.freemail.hu>
	<20110607083059.GB4133@elte.hu>
	<4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
Date: Wed, 8 Jun 2011 08:55:26 +0300
X-Google-Sender-Auth: jb_u-6Fxm39ZYHaWGQki_h0NOzg
Message-ID: <BANLkTikNuPg4nfXMqpffpt+5zZwLM_nSzw@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 2:24 AM,  <pageexec@freemail.hu> wrote:
> to give you an idea:
> - if a code path executes in 1M or 1K cycles once every hour, then
>  it's not a fast path, it doesn't matter to anyone whether it runs
>  1 or 10 cycles faster or not,

I'm pretty sure people who try to optimize kernel boot times, for
example, don't agree with you.

                                        Pekka
