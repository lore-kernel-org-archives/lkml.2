Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2KIHbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 02:31:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2KIHbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 02:31:34 -0500
Message-ID: <509CB151.40207@kernel.dk>
Date: Fri, 09 Nov 2012 08:31:29 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ed Cashin <ecashin@coraid.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] aoe: avoid running request handler on plugged queue
References: <cover.1352410985.git.ecashin@coraid.com> <a9c04c2664148dae99208fdd69ee20f6a4b68120.1352410985.git.ecashin@coraid.com>
In-Reply-To: <a9c04c2664148dae99208fdd69ee20f6a4b68120.1352410985.git.ecashin@coraid.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-09 01:17, Ed Cashin wrote:
> Calling the request handler directly on a plugged queue defeats
> the performance improvements provided by the plugging mechanism.
> Use the __blk_run_queue function instead of calling the request
> handler directly, so that we don't interfere with the block
> layer's ability to plug the queue.

Thanks Ed, applied!

-- 
Jens Axboe

