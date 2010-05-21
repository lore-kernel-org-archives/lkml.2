Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0EUJ6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:58:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48671 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016Ab0EUJ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:58:53 -0400
Date: Fri, 21 May 2010 11:05:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
Message-ID: <20100521110549.388b9f4e@lxorguk.ukuu.org.uk>
In-Reply-To: <20100520194509.GB10739@sirena.org.uk>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
	<1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
	<20100520194509.GB10739@sirena.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> stable and software has to cope with fewer events.  We've lived without
> it for quite some time, though.

We lived without graphics for quite some time, without 64bit for quite
some time ;)

Alan
