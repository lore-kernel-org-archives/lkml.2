Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2GFR4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:56:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63908 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab2GFR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:56:00 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.10.162]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F92EFE2@EXDCVYMBSTM005.EQ1STM.local>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbbG2nHH7+rm6CoR=VhiXVQT3-2VqJYLswmg9EshWu_=EA@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C10579232F86BE52@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=Wgbb_pAx9Kfwbh23k=62vQUx5vnVpwe3q50BY=KwAkLC=ng@mail.gmail.com> <81C3A93C17462B4BBD7E272753C10579232F92EFE2@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 6 Jul 2012 20:55:39 +0300
Message-ID: <CAK=Wgbbt4E7RNntRp4K2q5i2rw6ZpVfxbVrH9u4djJus0L5AJg@mail.gmail.com>
Subject: Re: [RFC 4/4] remoteproc: Add driver for STE Modem
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Jul 6, 2012 at 12:18 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> The simple story is that when Host writes a bit indicated with TX-mask
> it generates an interrupt on the modem-side. And likewise when the
> modem writes a bit indicated with RX mask the Host will receive an
> interrupt.

Ok, thanks.

> Yes, if you can guarantee this, I could make a very simple solution.

Great!

> Ok, I guess a more standard way to solve this is use #ifdef's and
> dummy inline functions in the header file instead. I'll do that
> next time around then.

I'm still puzzled a bit about this: can we just depend on some
CONFIG_STE_MODEM_HANDLERS (totally made up name) instead, without even
adding the #ifdefs ?

Since ste_modem_rproc is anyway platform specific, I'm wondering
whether there's any legitimate configuration where it is needed, but
the symbols it depends on aren't around.

> OK, we can do it this way as well. It feels a bit over-the-top in my case,
> but I understand where you're coming from any why.

Thanks! It should really be super simple and straight-forward to
implement. If you see that for some reason it isn't, let me know and
I'll help.

Ohad.
