Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0L1Sjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 13:39:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:54828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab0L1Sjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 13:39:52 -0500
Date: Tue, 28 Dec 2010 10:39:40 -0800
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCH 16/16] staging: convert to bdops->check_events()
Message-ID: <20101228183940.GA11830@suse.de>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
 <1293557352-10592-17-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293557352-10592-17-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 06:29:12PM +0100, Tejun Heo wrote:
> Convert two staging drivers - blkvsc_drv and cyasblkdev_block - from
> ->media_changed() to ->check_events().  The former always indicated
> media changed while the latter always indicated media not changed.
> Not sure what the drivers are trying to achieve but keep the original
> behavior.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
