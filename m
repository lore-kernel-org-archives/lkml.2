Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab2HEGvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 02:51:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:37482 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2HEGvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 02:51:12 -0400
Message-ID: <1344149396.24037.86.camel@pasglop>
Subject: Re: Is iommu_num_pages() broken ?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Anton Blanchard <anton@au1.ibm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org
Date: Sun, 05 Aug 2012 16:49:56 +1000
In-Reply-To: <m24nohsuz8.fsf@linux-m68k.org>
References: <1344125816.24037.84.camel@pasglop>
	 <m24nohsuz8.fsf@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-05 at 08:39 +0200, Andreas Schwab wrote:
> addr & (io_page_size - 1) computes the offset into the page pointed to
> by addr.  Looks right to me.
> 
> addr & ~(io_page_size - 1) would round addr down to the start of the
> page.

Ah that's right, for some reason I'm so used to seeing ~ before such
constructs that my brain must have imagined it :-)

Sorry for the noise. Next time I'll have coffee first then re-check ...

Cheers,
Ben.

