Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1HGTsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 15:48:06 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:55866 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1HGTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 15:48:04 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Joachim Eastwood <manabian@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@cam.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
	<CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
	<CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
	<CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
	<CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
	<CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
	<d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com>
	<CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
X-Yow: Is this an out-take from the ``BRADY BUNCH''?
Date: Sun, 07 Aug 2011 21:47:58 +0200
In-Reply-To: <CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
	(Joachim Eastwood's message of "Sun, 7 Aug 2011 20:57:36 +0200")
Message-ID: <m2liv5ovf5.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joachim Eastwood <manabian@gmail.com> writes:

> On Sun, Aug 7, 2011 at 8:38 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> There aren't many users of that define, could you just turn it back to the proper 16, and then try changing it to 80 in each place that uses it?
>>
>> That way we'd see exactly *which* use is the buggy one..
>
> Its drivers/char/random.c.

ARM has its own implementation of sha_transform in arch/arm/lib/sha1.S,
which assumes SHA_WORKSPACE_WORDS is 80.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
