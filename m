Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2IYRib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:38:31 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:34257 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526Ab2IYRi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:38:29 -0400
Date: Tue, 25 Sep 2012 19:37:44 +0200
From: matthieu castet <castet.matthieu@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] hvc_dcc : add support to armv4 and armv5 core
Message-ID: <20120925193744.655059d5@mat-laptop>
In-Reply-To: <201209251544.57998.arnd@arndb.de>
References: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr>
	<201209031257.28213.arnd@arndb.de>
	<5061CF5A.2030201@parrot.com>
	<201209251544.57998.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 25 Sep 2012 15:44:57 +0000,
Arnd Bergmann <arnd@arndb.de> a écrit :

> 
> It's not possible to build a kernel that runs on ARMv5 (or below) and
> also on ARMv6 (or above), so the effect would be exactly the same.
> While we are putting a lot of effort into making all sorts of ARMv6
> and ARMv7 based systems work with the same kernel binary, it's highly
> unlikely we would ever need the above to be runtime selected, because
> there are a lot of other differences at assembly level.
> 
I know but Alan was not happy with the static version with ifdef [1]
[2]. That why a dynamic version was done.


Matthieu


[1]
> > There are no plans to ever make it possible; there are too many
> > significant differences between ARMv4, v5 architectures and
> > ARMv6,v7 architectures to warrant making this runtime selectable.  
> 
> Then bury this crap in platform files please not in the drivers/tty
> layer code. Make it a platform driver provided callback or something.
> 
> Alan

[2]
> > I posted a new v2 patch that make the selection dynamic.  
> 
> Thanks - fine with that one - or with burying it in headers etc in
> the arm subdirs.
