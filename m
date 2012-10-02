Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2JBMPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:15:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58732 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2JBMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:15:38 -0400
Date: Tue, 2 Oct 2012 13:15:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 08/10] ARM: ux500: Stop calling the UIB init function
 when using Device Tree
Message-ID: <20121002121533.GA26783@gmail.com>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
 <1349165603-24401-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdaM1SxcrAn086W+b-oC+k6w=SEhxq0CGqrA_4iXmgfWYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaM1SxcrAn086W+b-oC+k6w=SEhxq0CGqrA_4iXmgfWYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2012, Linus Walleij wrote:

> On Tue, Oct 2, 2012 at 10:13 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > As there will be a Device Tree created for the UIBs, there is no
> > need to call the UIB initiation functions. Each device will be
> > detailed and registered from the Device Tree instead.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by, but...
> 
> > -       .init_late      = ux500_init_late,
> > +       .init_late      = NULL,
> 
> Why even define it?

More to show that we're _intentionally_ not using it.

I'm happy to remove if it offends you? :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
