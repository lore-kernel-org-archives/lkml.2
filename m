Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2AOKdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 05:33:39 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57534
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab2AOKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 05:33:36 -0500
Date: Sun, 15 Jan 2012 05:33:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Block drivers for 3.3-rc
Message-ID: <20120115103331.GA31956@infradead.org>
References: <4F12A1CC.50105@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F12A1CC.50105@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 10:52:12AM +0100, Jens Axboe wrote:
> Hi Linus,
> 
> Please see below for the 3.3-rc1 block driver pull request.
> 
> Essentially two different categories here:
> 
> - Adds the driver for the Micron RealSSD P320 pci-express flash card.

The REQ_FUA and REQ_FLUSH handling in it is still completely broken,
with no attempt to fix it since it last came up.

So a pretty clear NAK on that driver from me.

