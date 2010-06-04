Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0FDBb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:31:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:50536 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab0FDBb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:31:57 -0400
Date: Fri, 4 Jun 2010 10:31:17 +0900
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       lethal@linux-sh.org
Subject: Re: [PATCH] arch/tile: respond to reviews of the second code
 submission.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201006032141.o53LfZC9019335@lab-15.internal.tilera.com>
References: <201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com>
	<201006032141.o53LfZC9019335@lab-15.internal.tilera.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100604103049M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 04 Jun 2010 10:31:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 17:32:17 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> This change addresses DMA-related comments by FUJITA Tomonori

What about the comment on dma_alloc_coherent()?

The rest changes look fine.
