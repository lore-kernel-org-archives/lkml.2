Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2LKJyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:54:41 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45497 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2LKJyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:54:39 -0500
Date: Tue, 11 Dec 2012 09:54:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 06/12] ARM: ux500: Set correct MMCI regulator voltages in
 the ux5x0 Device Tree
Message-ID: <20121211095433.GK9362@gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-7-git-send-email-lee.jones@linaro.org>
 <CACRpkdZJFbHSwowKnfWyXLckVePHrC6o2CtDJaFb+dXTkNYPjw@mail.gmail.com>
 <CAPDyKFo6KhshYJfSvodPK4e7zC25etz0G8fV4jnAssZX3BDZBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFo6KhshYJfSvodPK4e7zC25etz0G8fV4jnAssZX3BDZBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012, Ulf Hansson wrote:

> On 11 December 2012 10:17, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Mon, Dec 10, 2012 at 9:55 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> >> The voltages for the MMCI GPIO controlled voltage regulation differ
> >> depending on who you believe and where you pick the information up
> >> from. More recent internal code suggests that the true upper voltage
> >> from the shifter is actually v3.3, instead of the previously
> >> indicated v2.9. Let's mirror that change in the Device Tree file.
> 
> This is wrong. The value should be 2.9V nothing else!

Don't panic. I'm already on this. :)

> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > Yours,
> > Linus Walleij
> 
> Kind regards
> Ulf Hansson

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
