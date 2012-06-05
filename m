Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297Ab2FEBV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:21:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33750 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab2FEBVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:21:24 -0400
Date: Tue, 5 Jun 2012 09:21:16 +0800
From: Shaohua Li <shli@kernel.org>
To: Tao Guo <glorioustao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tao Guo <Tao.Guo@emc.com>,
        Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] block: Move general unplug callback function from
 md/raid to blk-core
Message-ID: <20120605012116.GA357@kernel.org>
References: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:41:50AM -0400, Tao Guo wrote:
> Other components may also require an unplug callback, so move this
> function from md/raid to block generic layer.

I saw no point this should be generic code, for example, why blk_plug_cb only
handles only one request_queue? If umem needs unplug, just do in it.
