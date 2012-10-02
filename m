Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2JBKOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:14:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:25619 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab2JBKOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,522,1344236400"; 
   d="scan'208";a="200544587"
Message-ID: <1349172879.13371.180.camel@smile>
Subject: Re: dmatest to use synopsys dma driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: dangdang168 <dangdang168@126.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 02 Oct 2012 13:14:39 +0300
In-Reply-To: <44802cba.213e8.1385a3c2807.Coremail.dangdang168@126.com>
References: <44802cba.213e8.1385a3c2807.Coremail.dangdang168@126.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 11:01 +0800, dangdang168 wrote: 
> Hi,
>        I  have the same problems  with  the description of
> "https://lkml.org/lkml/2012/6/11/322", could you give me some help
> with it ? thank you !
Could you try the very recent version from the linux-next?

Please, follow the discussions in the mailing list. Most of the related
patches are tagged as "dw_dmac". 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
