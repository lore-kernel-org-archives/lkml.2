Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3AHATy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:19:54 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:38374 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3AHATw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:19:52 -0500
Date: Tue, 8 Jan 2013 09:19:47 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/17] ARM: shmobile: fix memory size for kota2_defconfig
Message-ID: <20130108001947.GE16982@verge.net.au>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
 <CAOesGMg6afPjBc82FEOwzwn-nBAFPY7K_udJRJO1bBrtCk3Yvg@mail.gmail.com>
 <20130107015929.GA27346@verge.net.au>
 <201301071333.56733.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301071333.56733.arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 01:33:56PM +0000, Arnd Bergmann wrote:
> On Monday 07 January 2013, Simon Horman wrote:
> > I have my kota2 board up and running now and I believe that
> > the correct value is 0x1e000000. I will apply a patch to my
> > defconfigs branch accordingly.
> 
> Ok, thanks!
> 
> Should we mark that patch for stable backports?

I don't believe it warrants a stable backport as
the board appears to function well without the change.
