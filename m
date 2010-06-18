Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab0FRPWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:22:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56357 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0FRPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LbpC6TfVVZuqJP5ZP636HP3em/lk9iqjZHFHNU6E2Uz64vFwlkGWPYU2zcfzSy/JOz
         kzpCa+EWsxjtCDI0m73T5DigVcdxpvTSSSqirAED1gxrGhIRnmhExPGqSd1PYFeMmzq5
         sW94NjKOkKKbVHltRo45eX4KL4gd0Zd+t6akE=
MIME-Version: 1.0
In-Reply-To: <AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
References: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
	<AANLkTinji7n8Hd1Ldci_ruH0r8qglGjC00YQkb-MEwoV@mail.gmail.com>
	<AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
Date: Fri, 18 Jun 2010 17:22:47 +0200
Message-ID: <AANLkTim4Tn74BSTqpXMfZeAG9eLDYEKUbcN_wiw2HpBY@mail.gmail.com>
Subject: Re: [RESEND][REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: akpm@linux-foundation.org, tabbott@ksplice.com,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 4:27 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Jun 18, 2010 at 15:49, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> Andrew, Linus, Jeff, ... anyone?
>> Please apply this patch.
>>
>> CONFIG_STATIC_LINK is still broken. :(
>
> I wanted to verify Tim's patch, but after enabling CONFIG_STATIC_LINK,
> it fails to link
> (with or without your patch):
>

BTW: Does CONFIG_STATIC_LINK work for you when you revert commit
5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 (um: Clean up linker script
using standard macros)?

Cheers,
//richard
