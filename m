Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0ETTRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:17:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab0ETTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:17:41 -0400
Date: Thu, 20 May 2010 12:16:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
Message-Id: <20100520121652.cbcbb8b4.akpm@linux-foundation.org>
In-Reply-To: <20100520200417.5ec99735@lxorguk.ukuu.org.uk>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
	<1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
	<20100520110600.be702f58.akpm@linux-foundation.org>
	<20100520200417.5ec99735@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 20:04:17 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> 
> > > +EXPORT_SYMBOL_GPL(gpio_set_debounce);
> > 
> > nitlet: I suspect this function is taking gpio_lock sooner than it
> > strictly needs to.  Find-tuning that would decrease contention by an
> > insignificant amount ;)
> 
> We need this for Intel MID boxes as well Andrew - so its a generic need.
> 

Thanks.

I'm still wobbling on the 35-vs-36 line.  Is that a big need or a
little need?  What user-visible problem does it solve, etc?

Did anyone test it on the MID boxes?

etc ;)
