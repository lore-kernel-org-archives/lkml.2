Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0KJPXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:23:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:35356 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab0KJPXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:23:21 -0500
Subject: RE: [PATCH] ppc44x:PHY fixup for USB on canyonlands board
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rupjyoti Sarmah <rsarmah@apm.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <59d17e399e4efb295e802572f16cc395@mail.gmail.com>
References: <201011101137.oAABbFoc015547@amcc.com>
	 <20101110141914.GC26193@zod.rchland.ibm.com>
	 <59d17e399e4efb295e802572f16cc395@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 02:22:55 +1100
Message-ID: <1289402575.2147.1399.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 20:13 +0530, Rupjyoti Sarmah wrote:
> >Is this just for canyonlands?  If so, it's probably better off in a
> >caynonlands specific file, or a function that gets called in the common
> >platform file if the model matches canyonlands.  It seems a bit overkill
> >to introduce an entire new file and Kconfig option for this.
> 
> 
> We want to have a file that will have fixup codes for all the ppc44x
> specific boards. Within this ppc44x_fixup.c file we would like to place
> any fixup code that
> might come later for any of the ppc44x based boards. Although I released
> it only with Canyonlands code, it would be ppc44x specific file.
> 
> Do let me know if that is ok.

No. You should have a file per board that needs fixup. Take them out of
ppc4xx_simple.c and create a board file.

Cheers,
Ben.


