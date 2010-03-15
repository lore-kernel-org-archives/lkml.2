Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635Ab0COSSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:18:32 -0400
Received: from isilmar.linta.de ([213.133.102.198]:33334 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965596Ab0COSSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:18:31 -0400
Date: Mon, 15 Mar 2010 19:18:29 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Cox <alan@linux.intel.com>
Cc: Jan Beulich <JBeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: pcmcia's use of IRQ_NOAUTOEN
Message-ID: <20100315181829.GA26096@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Alan Cox <alan@linux.intel.com>, Jan Beulich <JBeulich@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <4B94DCB7020000780003337B@vpn.id2.novell.com> <20100308194757.GB17628@isilmar.linta.de> <20100315174359.7fa53d4b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315174359.7fa53d4b@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Mar 15, 2010 at 05:43:59PM +0000, Alan Cox wrote:
> > You're right, it seems to make no sense. Or less than that.
> > 
> > Alan, what do you think?
> 
> It should be setting the correct NOAUTOEN bits so that the IRQ isn't
> randomly enabled as some hardware then crashes. How it ended up wrong
> upstream I don't know as it was tested and fixed the bug, so presumably
> the right version got tested or it happened to work back on the old irq
> code by luck.

http://lkml.org/lkml/2007/4/5/127 and then
http://lkml.org/lkml/2007/4/26/485 talk a different language :(

> I don't think you are overlooking anything - there is no deep magic
> involved.

I'll just revert it.

Best,
	Dominik
