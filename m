Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1FFRiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:38:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46097 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1FFRiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinxYQa=EU=t4m8VUT4X9h0xvaaXQg@mail.gmail.com>
References: <20110606070553.9829.40823.stgit@ponder> <BANLkTim3RgRJoNY61iRuCELvyuNhm==PtA@mail.gmail.com>
 <BANLkTinxYQa=EU=t4m8VUT4X9h0xvaaXQg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 11:37:58 -0600
X-Google-Sender-Auth: enieETdLd2IwBIMNnt5L3rzCBjs
Message-ID: <BANLkTi=LXBgyae2Man7PpqCwR7L0=R7pYg@mail.gmail.com>
Subject: Re: [PATCH] gpio: reorganize drivers
To: Roland Dreier <roland@purestorage.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 11:33 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jun 6, 2011 at 11:27 AM, Roland Dreier <roland@purestorage.com> wrote:
>> On Mon, Jun 6, 2011 at 12:06 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> Sort the gpio makefile and enforce the naming convention gpio-*.c for
>>> gpio drivers.
>>
>> OK, bikeshed colors here, but... what is the benefit of
>> 'drivers/gpio/gpio-xxx.c' vs
>> just 'drivers/gpio/xxx.c'?  Seems like one 'gpio' should be enough for anyone...
>
> lsmod

Specifically, module names don't give any clues about which directory
they were loaded out of, so it is useful to have the module name
reflect exactly what the module is for.  Second, a lot of these
gpio/spi/i2c cores end up being stuffed into an integrated chipset
where they all pretty much share the same name, but the drivers are
for different functional blocks.  ie. gpio-omap.o, spi-omap.o,
i2c-omap.o

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
