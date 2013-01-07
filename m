Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3AGQJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:09:07 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:59797 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3AGQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:09:06 -0500
Date: Mon, 7 Jan 2013 17:09:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gerald Schaefer <geraldsc@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/io.h: convert readX defines to functions
Message-ID: <20130107160900.GB6898@osiris>
References: <20130107153459.GA6898@osiris>
 <12944963.pK1utZClTO@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12944963.pK1utZClTO@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 13010716-4966-0000-0000-0000048D5D05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 03:42:38PM +0000, Arnd Bergmann wrote:
> On Monday 07 January 2013 16:34:59 Heiko Carstens wrote:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> if you fix this:
> 
> > +#define readl readl
> > +static inline u32 __raw_readl(const volatile void __iomem *addr)
> > +{
> > +       return __le32_to_cpu(__raw_readl(addr));
> > +}
> 
> to be called readl rather than __raw_readl

duhh... thanks! :)

