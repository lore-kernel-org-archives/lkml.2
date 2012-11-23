Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2KWMbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:31:11 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:37148 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab2KWMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:31:09 -0500
Date: Fri, 23 Nov 2012 18:00:48 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, <linus.walleij@linaro.org>,
        <grant.likely@secretlab.ca>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
Message-ID: <20121123123048.GM5384@localhost.localdomain>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
 <20121123103400.GO17471@gmail.com>
 <CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
 <20121123121413.GB22268@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121123121413.GB22268@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 12:14:13PM +0000, Lee Jones wrote:
> > >> +             if (np)
> > >> +                     of_property_read_u32(np, "st,norequest-mask",
> > >> +                                     &pdata->norequest_mask);
> > >
> > > Can you explain to me what this does?
> > 
> > You mean pdata->norequest_mask?  It marks few gpios as unusable.
> > Because these pads might be used by other blocks of stmpe.
> 
> I'm not sure if that should be set with DT or not.
> 
> Second opinion anyone?

This is a board dependent parameter which just informs gpio driver
about pins, which must not be requested. It may happen for a stmpe
variant where such gpio pins are multiplexed with some other
function.

Hence it must be part of DT itself.

--
regards
Shiraz
