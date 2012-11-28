Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2K1JAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:00:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47451 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2K1JAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:00:34 -0500
Date: Wed, 28 Nov 2012 09:00:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rabin Vincent <rabin@rab.in>, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, l.fu@pengutronix.de
Subject: Re: [PATCH V3 3/3] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121128090028.GJ2013@gmail.com>
References: <7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org>
 <20121123094132.EFCB73E07BE@localhost>
 <CAKohpomAM2pw9kgB6khtHzQ2WCXKZ9_pi1_sOH2dQToVS8ep4w@mail.gmail.com>
 <20121126184015.784993E091F@localhost>
 <CAKohpo=dHz-fJRdwovOWesAZJwibgrNk-+2t--JK+T_sBsu9Tw@mail.gmail.com>
 <CAKohpomOxfLhpZqpk3aymdNa7UAGRcex7d+N5srkFDnrhtULTw@mail.gmail.com>
 <20121127084007.GA7897@gmail.com>
 <CAKohpomPMYU5H_tx1BF7TD6F7a5rp5O=xDf3r-TGZ-r9SBp3yA@mail.gmail.com>
 <CAH+eYFCshghQauBdn1rLQ-sKG=Bxa_0XpJsry60TAD3mibNOFA@mail.gmail.com>
 <CAKohpok6=O_TMaApYQGKbzHmJ8tkST5VAHDnLYgHb0g3gSPwbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpok6=O_TMaApYQGKbzHmJ8tkST5VAHDnLYgHb0g3gSPwbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012, Viresh Kumar wrote:

> On 28 November 2012 01:25, Rabin Vincent <rabin@rab.in> wrote:
> > 2012/11/27 Viresh Kumar <viresh.kumar@linaro.org>:
> >> On 27 November 2012 14:10, Lee Jones <lee.jones@linaro.org> wrote:
> >> I haven't seen this in any of SPEAr boards i have worked on. Maybe Rabin
> >> would have, that's why he added that part of code :)
> >>
> >> @Rabin/Linus: Do you remember why have you added this in stmpe driver:
> >>
> >> +       if (stmpe->pdata->irq_invert_polarity)
> >> +               icr ^= STMPE_ICR_LSB_HIGH;
> >> +
> >>
> >> Does somebody actually need it?
> >
> > It was (as irq_rev_pol) part of Luotao Fu's proposed STMPE811 patchset
> > (https://patchwork.kernel.org/patch/106173/) which I integrated into my
> > version of the STMPE driver, which didn't have it in its initial version
> > (https://patchwork.kernel.org/patch/103273/).
> >
> > It's not something _I_ ever used.
> 
> I grep'd kernel and nobody is using it there, so lets get rid of it
> completely :)
> I will patch it.

Great. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
