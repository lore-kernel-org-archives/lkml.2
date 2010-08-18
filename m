Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0HRF3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:29:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:48010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab0HRF32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:29:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,225,1280732400"; 
   d="scan'208";a="648783093"
Subject: number of elements or bytes for kfifo_in etc
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 13:29:25 +0800
Message-ID: <1282109365.2744.1549.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stefani,

In new kfifo implementation in 2.6.36-rc1, description of the third
parameter is:

"@n: number of elements to be added"

But if my understanding is correct, the actual implementation is:

"@n: number of bytes to be added"

That is sizeof(*fifo->type) is not considered.

I think we should change either the implementation or the description.

Best Regards,
Huang Ying


