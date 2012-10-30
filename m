Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab2J3EDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:03:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:50803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2J3EDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:03:13 -0400
Subject: Re: [PATCH] async_tx: use memchr_inv
From: Vinod Koul <vkoul@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dan Williams <djbw@fb.com>
In-Reply-To: <1351352973-3719-4-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
	 <1351352973-3719-4-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Oct 2012 09:19:53 +0530
Message-ID: <1351568993.7077.37.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 00:49 +0900, Akinobu Mita wrote:
> Use memchr_inv() to check the specified page is filled with zero.
> 
Applied Thanks

-- 
Vinod Koul
Intel Corp.

