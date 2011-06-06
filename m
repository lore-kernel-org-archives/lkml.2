Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1FFRdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:33:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60688 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1FFRdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:33:49 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim3RgRJoNY61iRuCELvyuNhm==PtA@mail.gmail.com>
References: <20110606070553.9829.40823.stgit@ponder> <BANLkTim3RgRJoNY61iRuCELvyuNhm==PtA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 11:33:29 -0600
X-Google-Sender-Auth: 2yRJBqPSsFsgtL-bP-zhMXz7Ay0
Message-ID: <BANLkTinxYQa=EU=t4m8VUT4X9h0xvaaXQg@mail.gmail.com>
Subject: Re: [PATCH] gpio: reorganize drivers
To: Roland Dreier <roland@purestorage.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 11:27 AM, Roland Dreier <roland@purestorage.com> wrote:
> On Mon, Jun 6, 2011 at 12:06 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Sort the gpio makefile and enforce the naming convention gpio-*.c for
>> gpio drivers.
>
> OK, bikeshed colors here, but... what is the benefit of
> 'drivers/gpio/gpio-xxx.c' vs
> just 'drivers/gpio/xxx.c'?  Seems like one 'gpio' should be enough for anyone...

lsmod

g.
