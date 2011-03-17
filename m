Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1CQVGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:06:30 -0400
Received: from science.horizon.com ([71.41.210.146]:62124 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755424Ab1CQVG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:06:29 -0400
Date: 17 Mar 2011 17:06:27 -0400
Message-ID: <20110317210627.21127.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, andreas.devel@googlemail.com
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in __mark_inode_dirty
Cc: aia21@cantab.net, axboe@kernel.dk, hch@lst.de, Jason@zx2c4.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@horizon.com, sergey.senozhatsky@gmail.com
In-Reply-To: <20110317140401.4f06793e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> afaik this regression didn't get fixed.  Jens put out a patch for
> George to test but there hasn't been any feedback on that yet.  Could
> you guys please give it a spin?

I'm running with it without problems, but the bug was hard (for me)
to trigger before.  So it's a very weak "Works For Me."
