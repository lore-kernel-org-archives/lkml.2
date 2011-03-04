Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab1CDPtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:49:41 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:32770 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759652Ab1CDPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:49:40 -0500
Date: Fri, 4 Mar 2011 16:49:12 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Maurus Cuelenaere <mcuelenaere@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Jz4740: Add HAVE_CLK
Message-ID: <20110304154912.GA24966@linux-mips.org>
References: <4d6c2da3.cc7e0e0a.2116.ffffde18@mx.google.com>
 <4D6CB9C4.8000609@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6CB9C4.8000609@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 10:17:56AM +0100, Lars-Peter Clausen wrote:

> On 03/01/2011 12:20 AM, Maurus Cuelenaere wrote:
> > Jz4740 supports the clock framework but doesn't have HAVE_CLK defined, so define
> > it!
> > 
> > Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks folks.  Applied,

  Ralf
