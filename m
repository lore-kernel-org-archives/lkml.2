Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0JDKM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:12:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:44765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab0JDKM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:12:56 -0400
Date: Mon, 4 Oct 2010 06:12:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20101004101212.GA25617@infradead.org>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
 <sQALkqF1FWE.A.15D.bo6nMB@chimera>
 <20101002165433.GL21129@thunk.org>
 <201010022358.35972.rjw@sisk.pl>
 <20101003022707.GN21129@thunk.org>
 <4CA89E63.4080907@kernel.org>
 <20101004095943.GE3589@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004095943.GE3589@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 11:59:44AM +0200, Jan Kara wrote:
>   Yes, it's caused by one of my fixes. It's harmless (the warning I've
> added is just too strict). Christoph has a patch that also fixes this
> - http://lkml.org/lkml/2010/9/29/76. I hope he'll push it soon.

Jens is the writeback maintainer, so he will have to pick it up.

