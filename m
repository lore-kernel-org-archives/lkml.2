Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937550Ab0CPHzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:55:19 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44358 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936551Ab0CPHzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:55:16 -0400
Date: Tue, 16 Mar 2010 08:55:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove GENHD_FL_DRIVERFS
Message-ID: <20100316075514.GU5768@kernel.dk>
References: <19358.65100.93577.71546@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19358.65100.93577.71546@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16 2010, NeilBrown wrote:
> 
> 
> This flag is not used, so best discarded.

Yep that looks pretty dead, thanks Neil, queued up.

-- 
Jens Axboe

