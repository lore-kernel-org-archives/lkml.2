Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1FHQ44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:56:56 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:35972 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751343Ab1FHQ4y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:56:54 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=LXBgyae2Man7PpqCwR7L0=R7pYg@mail.gmail.com>
References: <20110606070553.9829.40823.stgit@ponder> <BANLkTim3RgRJoNY61iRuCELvyuNhm==PtA@mail.gmail.com>
 <BANLkTinxYQa=EU=t4m8VUT4X9h0xvaaXQg@mail.gmail.com> <BANLkTi=LXBgyae2Man7PpqCwR7L0=R7pYg@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Wed, 8 Jun 2011 09:56:33 -0700
Message-ID: <BANLkTinqfMF0oxar2aPjnFP+1tL6j2_OwQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: reorganize drivers
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 10:37 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Specifically, module names don't give any clues about which directory
> they were loaded out of, so it is useful to have the module name
> reflect exactly what the module is for.  Second, a lot of these
> gpio/spi/i2c cores end up being stuffed into an integrated chipset
> where they all pretty much share the same name, but the drivers are
> for different functional blocks.  ie. gpio-omap.o, spi-omap.o,
> i2c-omap.o

OK, makes sense.

 - R.
