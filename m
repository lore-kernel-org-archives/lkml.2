Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270Ab2CFUbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:31:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36514 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030967Ab2CFUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:31:12 -0500
Date: Tue, 6 Mar 2012 21:31:06 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.4 for linux-block.git tree
 for 3.4 (don't see a branch though?)
Message-ID: <20120306203105.GG5403@kernel.dk>
References: <20120304183109.GB449@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120304183109.GB449@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04 2012, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch in your 3.4 tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.4
> 
> or the following git tag:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.4-tag
> 
> which makes the block backend able to work under an HVM domain (by default it was only
> working in PV), and some fixes and an performance improvement.
> 
> Please pull!

Pulled, thanks!

-- 
Jens Axboe

