Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2FULcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:32:46 -0400
Received: from h9.dl5rb.org.uk ([81.2.74.9]:52045 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759226Ab2FULco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:32:44 -0400
Date: Thu, 21 Jun 2012 12:32:34 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Kelvin Cheung <keguang.zhang@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, zhzhl555@gmail.com
Subject: Re: [PATCH V7 2/4] MIPS: Add board support for Loongson1B
Message-ID: <20120621113234.GB7175@linux-mips.org>
References: <1339757617-2187-1-git-send-email-keguang.zhang@gmail.com>
 <20120620192551.GC29446@linux-mips.org>
 <4FE225F3.4080806@mvista.com>
 <1463808.aB2kcWCEuH@bender>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463808.aB2kcWCEuH@bender>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:10:26PM +0200, Florian Fainelli wrote:

> > > This redefines a function that already is declared in <linux/clk.h> and
> > > defined in drivers/clk/clkdev.c.  Why?
> > 
> >     Because he doesn't support clkdev? clkdev support is optional.
> 
> I don't think it is a good idea not to support clkdev for new targets. Ralf 
> what do you think about it?

My gut feeling is that if there's a suitable generic infrastructure we
should use it, so use clkdev for new targets.  I was just wondering if
there's a good reason to doing things the way he did.

  Ralf
