Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab2J2GHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:07:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:44431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab2J2GHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:07:14 -0400
Subject: Re: [PATCH] dmatest: adjust invalid module parameters for number
 of source buffers
From: Vinod Koul <vkoul@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dan Williams <djbw@fb.com>
In-Reply-To: <1351352973-3719-3-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
	 <1351352973-3719-3-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 11:24:08 +0530
Message-ID: <1351490048.7077.35.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 00:49 +0900, Akinobu Mita wrote:
> DMA Engine test module has module parameters to set the number of source
> buffers for xor and pq operations.  We can set these values larger than the
> maximum number of sources that the device can support.  These values are
> not adjusted and the unsupported number of source buffers are passed to the
> device.  But most drivers don't check it, so unexpected results will happen.
> 
> This makes an appropriate adjustment for these module parameters before use. 
Applied thanks

-- 
Vinod Koul
Intel Corp.

