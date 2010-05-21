Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0EUN2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:28:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59650 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753427Ab0EUN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:28:03 -0400
Date: Fri, 21 May 2010 14:34:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: felipe.balbi@nokia.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
Message-ID: <20100521143432.5de6ebec@lxorguk.ukuu.org.uk>
In-Reply-To: <396934.73027.qm@web180307.mail.gq1.yahoo.com>
References: <20100521111136.53dba6c9@lxorguk.ukuu.org.uk>
	<396934.73027.qm@web180307.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One of the earlier examples of why to want debouncing (in the
> original discussion, not this one) was for buttons (one signal
> per button press) and the hardware designers don't necessarily
> hook buttons up to only GPIOs with hardware debounce.  So code
> to kick in debounce there needed to be sensitive to whether or
> not the capability was available ... and moreover, whether the
> debounce scale was adequate to compensate the contact chatter.
> When not, then software debounce was inescapable.

And someone who needs it can contribute it. The proposed patch causes no
problems in this area.

Alan
