Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2FMTUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:20:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2FMTUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:20:11 -0400
Date: Wed, 13 Jun 2012 21:20:00 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd fixes
Message-ID: <20120613192000.GE8230@kernel.dk>
References: <1788738.mNsnrf6o6T@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1788738.mNsnrf6o6T@fat-tyre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2012, Philipp Reisner wrote:
> Hi Jens,
> 
> In the last 4 weeks three bugs were reported and fixed. Please consider
> to pass these 3 commits on to Linus.
> 
> The following changes since commit 4fd1ffaa122cf66bfb710ced43679413df4f3605:
> 
>   Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-3.5/drivers (2012-05-18 16:20:06 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.drbd.org/linux-drbd.git for-jens
> 
> for you to fetch changes up to 0d5934e3c258fc5decc4103600c597086fd95a52:
> 
>   drbd: fix null pointer dereference with on-congestion policy when diskless (2012-06-12 14:35:19 +0200)

Pulled, thanks.

-- 
Jens Axboe

