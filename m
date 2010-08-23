Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0HWJCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:02:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51765 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0HWJCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:02:33 -0400
Message-ID: <4C723929.2070908@kernel.dk>
Date: Mon, 23 Aug 2010 11:02:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: disable doorbell reset on reset_devices
References: <20100818144516.21791.86572.stgit@beardog.cce.hp.com>
In-Reply-To: <20100818144516.21791.86572.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-18 16:45, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> The doorbell reset initially appears to work correctly,
> the controller resets, comes up, some i/o can even be
> done, but on at least some Smart Arrays in some servers,
> it eventually causes a subsequent controller lockup due
> to some kind of PCIe error, and kdump can end up leaving
> the root filesystem in an unbootable state.  For this
> reason, until the problem is fixed, or at least isolated
> to certain hardware enough to be avoided, the doorbell
> reset should not be used at all.

Thanks Stephen, applied.

-- 
Jens Axboe

