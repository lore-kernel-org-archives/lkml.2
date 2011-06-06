Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1FFR1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:27:39 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:52359 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752121Ab1FFR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110606070553.9829.40823.stgit@ponder>
References: <20110606070553.9829.40823.stgit@ponder>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 6 Jun 2011 10:27:17 -0700
Message-ID: <BANLkTim3RgRJoNY61iRuCELvyuNhm==PtA@mail.gmail.com>
Subject: Re: [PATCH] gpio: reorganize drivers
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:06 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Sort the gpio makefile and enforce the naming convention gpio-*.c for
> gpio drivers.

OK, bikeshed colors here, but... what is the benefit of
'drivers/gpio/gpio-xxx.c' vs
just 'drivers/gpio/xxx.c'?  Seems like one 'gpio' should be enough for anyone...

 - R.
