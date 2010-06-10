Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab0FJGBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:01:38 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49311 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0FJGBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:01:36 -0400
Message-ID: <4C107FBF.9050209@kernel.dk>
Date: Thu, 10 Jun 2010 08:01:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the drbd tree with the block trees
References: <20100610135203.4649453a.sfr@canb.auug.org.au>
In-Reply-To: <20100610135203.4649453a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-10 05:52, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the drbd tree got a conflicts in
> fs/fs-writeback.c against the block tree.
> 
> It looks like the block tree has moved under the drbd tree again.  I used
> the version of this file from the block tree for today.

I'm starting to think that it would be a little easier if you did not
pull the drbd tree, I really should be pulling that into my -next branch
instead.

-- 
Jens Axboe

