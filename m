Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0IOOW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:22:29 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44621 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab0IOOW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:22:28 -0400
Message-ID: <4C90D6A3.8070101@kernel.dk>
Date: Wed, 15 Sep 2010 16:22:27 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Karel Zak <kzak@redhat.com>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v4 1/3] block, partition: add partition_meta_info to hd_struct
References: <1280946126-19587-3-git-send-email-wad@chromium.org> <1283287627-13842-1-git-send-email-wad@chromium.org>
In-Reply-To: <1283287627-13842-1-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-31 22:47, Will Drewry wrote:
> I'm reposting this patch series as v4 since there have been no additional
> comments, and I cleaned up one extra bit of unneeded code (in 3/3). The patches
> are against Linus's tree: 2bfc96a127bc1cc94d26bfaa40159966064f9c8c
> (2.6.36-rc3).

I've included them in the for-2.6.37/core branch.

-- 
Jens Axboe

