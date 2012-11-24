Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2KXIPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:15:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33842 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2KXIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:15:43 -0500
Date: Sat, 24 Nov 2012 00:15:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [PATCH 0/2] Input: nomadik-ske-keypad - clk fixups
Message-ID: <20121124081539.GC24711@core.coreip.homeip.net>
References: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
 <CAPDyKFq+MBo2338SiAF-mdDHpgTDJ0p6k2BaicJpSutGqtaubA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFq+MBo2338SiAF-mdDHpgTDJ0p6k2BaicJpSutGqtaubA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Fri, Nov 23, 2012 at 04:54:09PM +0100, Ulf Hansson wrote:
> On 1 November 2012 15:20, Ulf Hansson <ulf.hansson@stericsson.com> wrote:
> > From: Ulf Hansson <ulf.hansson@linaro.org>
> >
> > Due to the convert to the common clk driver these changes for clks are needed.
> >
> > Ulf Hansson (2):
> >   Input: nomadik-ske-keypad - fixup use of clk
> >   Input: nomadik-ske-keypad - start using the apb_pclk
> >
> >  drivers/input/keyboard/nomadik-ske-keypad.c |   34 +++++++++++++++++++++++----
> >  1 file changed, 29 insertions(+), 5 deletions(-)
> >
> > --
> > 1.7.10
> >
> 
> Just a kind reminder here. Do we see any issues with merging this?

Both are in my 'next' branch, sorry for not notifying you earlier.

-- 
Dmitry
