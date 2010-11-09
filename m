Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0KIQa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:30:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54582 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0KIQa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:30:57 -0500
Date: Tue, 9 Nov 2010 16:30:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101109163043.GA6961@sirena.org.uk>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com> <20101106181202.GA6927@kroah.com> <20101106192259.GB2935@thunk.org> <AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com> <20101106234029.GC2935@thunk.org> <alpine.DEB.2.00.1011061646170.29342@asgard.lang.hm> <20101107000348.GF2935@thunk.org> <20101107001341.4e39c631@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107001341.4e39c631@lxorguk.ukuu.org.uk>
X-Cookie: Beware the new TTY code!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 12:13:41AM +0000, Alan Cox wrote:

> I've always wondered that but never seen a good answer from the Android
> people as to why they don't push the stuff without the wakelock bits and
> just keep "add wakelock" patches for those as they do for the core kernel
> stuff they hack about.

Much of this code has other serious issues (eg, code quality or being
written for out of date kernel APIs) which prevents it being merged
without other work.

There are also some other areas where Android introduced random API
variance, though none of them terribly important.
