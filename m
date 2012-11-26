Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2KZL2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:28:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50302 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2KZL23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:28:29 -0500
Date: Mon, 26 Nov 2012 11:28:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>, linus.walleij@linaro.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
Message-ID: <20121126112823.GI12782@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
 <20121123103400.GO17471@gmail.com>
 <CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
 <20121123121413.GB22268@gmail.com>
 <20121123123048.GM5384@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121123123048.GM5384@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Shiraz Hashim wrote:

> On Fri, Nov 23, 2012 at 12:14:13PM +0000, Lee Jones wrote:
> > > >> +             if (np)
> > > >> +                     of_property_read_u32(np, "st,norequest-mask",
> > > >> +                                     &pdata->norequest_mask);
> > > >
> > > > Can you explain to me what this does?
> > > 
> > > You mean pdata->norequest_mask?  It marks few gpios as unusable.
> > > Because these pads might be used by other blocks of stmpe.
> > 
> > I'm not sure if that should be set with DT or not.
> > 
> > Second opinion anyone?
> 
> This is a board dependent parameter which just informs gpio driver
> about pins, which must not be requested. It may happen for a stmpe
> variant where such gpio pins are multiplexed with some other
> function.
> 
> Hence it must be part of DT itself.

Doesn't pinctrl normally handle this kind of stuff?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
