Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2IYMw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:52:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:58972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2IYMw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:52:26 -0400
Message-ID: <5061A8EA.6040702@kernel.dk>
Date: Tue, 25 Sep 2012 14:51:54 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Shaohua Li <shli@fusionio.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
References: <20120924145639.3b65fd8b@notabene.brown>
In-Reply-To: <20120924145639.3b65fd8b@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 06:56 AM, NeilBrown wrote:
> 
> Hi Jens,
>  this patch has been sitting in my -next tree for a little while and I was
>  hoping for it to go in for the next merge window.
>  It simply allows bio_split() to be used on bios without a payload, such as
>  'discard'.
>  Are you happy with it going in though my 'md' tree, or would you rather take
>  it though your 'block' tree?

It should go through my tree, especially since we've got conflicts with
other changes. In other words, your patch does not apply to for-3.7/core
as-is...

Shaohua, could you resend an updated variant?

-- 
Jens Axboe

