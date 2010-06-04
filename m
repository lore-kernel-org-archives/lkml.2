Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0FDAuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:50:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47682 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab0FDAug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:50:36 -0400
Date: Fri, 4 Jun 2010 09:50:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] arch/tile: respond to reviews of the second code submission.
Message-ID: <20100604005010.GC31868@linux-sh.org>
References: <201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com> <201006032141.o53LfZC9019335@lab-15.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006032141.o53LfZC9019335@lab-15.internal.tilera.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:32:17PM -0400, Chris Metcalf wrote:
> This change addresses DMA-related comments by FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> and Kconfig-related comments by Paul
> Mundt <lethal@linux-sh.org>.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Looks good to me. Feel free to add my reviewed-by to the series.

Reviewed-by: Paul Mundt <lethal@linux-sh.org>
