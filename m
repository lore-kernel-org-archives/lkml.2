Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0GNDQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 23:16:46 -0400
Received: from verein.lst.de ([213.95.11.210]:39839 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0GNDQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 23:16:45 -0400
Date: Wed, 14 Jul 2010 05:16:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 4/5] block: Add secure discard
Message-ID: <20100714031632.GA346@lst.de>
References: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com> <20100707111749.24979.69982.sendpatchset@ahunter-work.research.nokia.com> <4C3C0A71.2080407@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3C0A71.2080407@nokia.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches look good to me, but they'll need some work to apply against
Jens' block tree.

