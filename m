Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0LXKxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 05:53:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:26969 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab0LXKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 05:53:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,223,1291622400"; 
   d="scan'208";a="586920052"
Date: Fri, 24 Dec 2010 11:53:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/20] mfd/ab8500: remove spi support
Message-ID: <20101224105345.GC27832@sortiz-mobl>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
 <1291388753-14662-2-git-send-email-sundar.iyer@stericsson.com>
 <20101209142912.GM8884@sortiz-mobl>
 <33A307AF30D7BF4F811B1568FE7A9B18047C7D405F@EXDCVYMBSTM006.EQ1STM.local>
 <20101209153634.GQ8884@sortiz-mobl>
 <AANLkTikG7CY9hcuSy6+na+xrjbJYdKE3tRysT0FKw5kD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikG7CY9hcuSy6+na+xrjbJYdKE3tRysT0FKw5kD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Dec 19, 2010 at 09:48:46PM +0100, Linus Walleij wrote:
> 2010/12/9 Samuel Ortiz <sameo@linux.intel.com>:
> 
> >> [Sundar]
> >> >> Since the Ab8500 v1.0, the SPI support is deprecated on the HW.
> >> >I'm fine with that, but you really don't want to be able to support pre 1.0
> >> >devices ?
> >>
> >> AFAIK, there aren't active pieces of those outside STE :)
> > Ok, that's a good reason. Please add my:
> > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> This better be merged through the MFD tree. It touches a line in
> the Makefile that has been changed since, the fixup is trivial but
> it's orthogonal to the stuff I have in ux500-core anyway so Sam,
> can you merge this into MFD?
Sure, patch applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
