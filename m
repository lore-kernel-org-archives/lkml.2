Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab2KAKHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:07:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:33164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab2KAKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:07:04 -0400
Date: Thu, 1 Nov 2012 11:06:58 +0100
From: Jens Axboe <jaxboe@fusionio.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] 4 fixes for drbd
Message-ID: <20121101100658.GM27975@kernel.dk>
References: <3728568.yDZLErye6B@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3728568.yDZLErye6B@fat-tyre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2012, Philipp Reisner wrote:
> Hi Jens,
> 
> please consider to pull these fixes in. It is based on your
> for-3.7/drivers branch.
> 
> Best regards,
>  Phil
> 
> 
> The following changes since commit 34a73dd594699dc3834167297a74c43948bb6e41:
> 
>   Revert "memstick: add support for legacy memorysticks" (2012-10-10 16:13:26 
> -0600)
> 
> are available in the git repository at:
> 
>   git://git.drbd.org/linux-drbd.git for-jens
> 
> for you to fetch changes up to 731d4596a6f3ba41418a0b11018c453456c51d92:
> 
>   drbd: check return of kmalloc in receive_uuids (2012-10-29 13:18:13 +0100)

Can you rebase this against for-3.8/drivers? Thanks.

-- 
Jens Axboe

