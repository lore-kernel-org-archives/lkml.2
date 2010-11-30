Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab0K3UA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:00:29 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57590 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752228Ab0K3UA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:00:28 -0500
Date: Tue, 30 Nov 2010 21:00:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: bkuhn@ebb.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101130200019.GA28735@elf.ucw.cz>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <20101118113441.74fcdc21@lxorguk.ukuu.org.uk>
 <AANLkTikOZbtyhsk0OBb4OdUi6qj-7k_hU-aW_Pkhfpq0@mail.gmail.com>
 <20101130192648.GA1623@ucw.cz>
 <AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-11-30 11:30:18, Luis R. Rodriguez wrote:
> On Tue, Nov 30, 2010 at 11:26 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> >> everything else can be independent code. For ath9k in particular this
> >> >> means we keep ath9k_hw shared between our Operating Systems and that's
> >> >> it. In addition to this I believe opening up the common drivers for
> >> >
> >> > The Linux copy needs to be GPL,
> >>
> >> GPL-Compatible you mean, right. I mean we have ath9k_hw with
> >> permissive licensed files.
> >
> > GPL-compatible is not right word. It has to be either GPL, or so
> > permissive that anyone is allowed to turn it into GPL.
> 
> Oh?

Kernel is GPL. Dual BSD/GPL is ok. Just BSD... I don't think so.

/*
 * Copyright (c) 2008 Atheros Communications Inc.
 *
 * Permission to use, copy, modify, and/or distribute this software
for any
 * purpose with or without fee is hereby granted, provided that the
above
 * copyright notice and this permission notice appear in all copies.
 *

...but I need permission to relicense it under GPL, and I'm not sure I
have it.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
