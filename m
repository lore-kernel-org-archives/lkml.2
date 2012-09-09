Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2IIPgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:36:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58139 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2IIPgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:36:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120909155424.862635h7ncykg9s0@www.81.fi>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com> <20120909155424.862635h7ncykg9s0@www.81.fi>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Sep 2012 08:35:56 -0700
X-Google-Sender-Auth: U_LsyrZ1w0mkTstqcSdwnaFK7Uo
Message-ID: <CA+55aFyM52LaD_fF+dwjF1aKKeVCpHpBVqAQeEAZLB+Mnrgsig@mail.gmail.com>
Subject: Re: Linux 3.6-rc5
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 5:54 AM, Jussi Kivilinna
<jussi.kivilinna@mbnet.fi> wrote:
>
> Does reverting e46e9a46386bca8e80a6467b5c643dc494861896 help?
>
> That commit added crypto selftest for authenc(hmac(sha1),cbc(aes)) in 3.6,
> and probably made this bug visible (but not directly causing it).

So Romain said it does - where do we go from here? Revert testing it,
or fix the authenc() case? I'd prefer the fix..

                 Linus
