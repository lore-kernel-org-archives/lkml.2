Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0JOHQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:16:54 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:44622 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128Ab0JOHQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:16:53 -0400
Message-ID: <4CB7FFAD.9060009@stericsson.com>
Date: Fri, 15 Oct 2010 09:15:57 +0200
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Richard Scobie <richard@sauce.co.nz>
Subject: Re: [GIT PATCH] ioat2: fix performance regression
References: <20101013230248.32594.35857.stgit@localhost6.localdomain6>
In-Reply-To: <20101013230248.32594.35857.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:

> Commit 0793448 "DMAENGINE: generic channel status v2" changed the interface for
> how dma channel progress is retrieved.  It inadvertently exported an internal
> helper function ioat_tx_status() instead of ioat_dma_tx_status().

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
