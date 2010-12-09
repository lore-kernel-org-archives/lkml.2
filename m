Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0LIPgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:36:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:37222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0LIPgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:36:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="685518038"
Date: Thu, 9 Dec 2010 16:36:35 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/20] mfd/ab8500: remove spi support
Message-ID: <20101209153634.GQ8884@sortiz-mobl>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
 <1291388753-14662-2-git-send-email-sundar.iyer@stericsson.com>
 <20101209142912.GM8884@sortiz-mobl>
 <33A307AF30D7BF4F811B1568FE7A9B18047C7D405F@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B18047C7D405F@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

On Thu, Dec 09, 2010 at 03:35:05PM +0100, Sundar R IYER wrote:
> Hi Sam,
> 
> [pruning up the CC list]
> 
> >-----Original Message-----
> >From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> >
> >> Since the Ab8500 v1.0, the SPI support is deprecated on the HW.
> >I'm fine with that, but you really don't want to be able to support pre 1.0
> >devices ?
> 
> AFAIK, there aren't active pieces of those outside STE :) 
Ok, that's a good reason. Please add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
