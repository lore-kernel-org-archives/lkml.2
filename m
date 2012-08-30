Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2H3X4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:56:07 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49162 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2H3X4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120828074812.GA12957@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-14-git-send-email-lee.jones@linaro.org>
	<CACRpkdaem6t3mvy-_9e=GEgwWoeBQSoX3Hf1L=hjWsvLJdsVAQ@mail.gmail.com>
	<20120820080632.GD8450@gmail.com>
	<CACRpkdZRJ1yX-o8-NUuMzXMz5ebbp=H21Xa6JMy1y56Chq-T9g@mail.gmail.com>
	<20120828074812.GA12957@gmail.com>
Date: Thu, 30 Aug 2012 16:56:03 -0700
Message-ID: <CACRpkdY0jwV7MOOGbFOcFhujMzanRyxx6TofA72ZwLi_D4HhHw@mail.gmail.com>
Subject: Re: [PATCH 13/22] ARM: ux500: Fork MSP platform registration for
 step-by-step DT enablement
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 12:48 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, Aug 27, 2012 at 04:07:58PM -0700, Linus Walleij wrote:

>> If you're adding and then removing *all* of them in this set,
>> why add them in the first place?
>
> So that there's no breakage during bisection.
>
> You should be able to roll the kernel back in between each of these
> patches and there to be full compatibility at each point. At least
> that was the intention. Is that wrong?

No it's correct, the only way to do what I'm thinking on may be
to squash them all into one gigantic patch, which is not good either.

So go ahead with this scheme, it's the lesser of two evils.
Acked-by etc.

Yours,
Linus Walleij
