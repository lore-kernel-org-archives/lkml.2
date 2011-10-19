Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1JSSE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:04:27 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:35462
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1JSSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:04:26 -0400
Message-ID: <4E9F1128.8080207@kernel.dk>
Date: Wed, 19 Oct 2011 20:04:24 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, vgoyal@redhat.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCH 10/10] block: fix request_queue lifetime handling by making
 blk_queue_cleanup() proper shutdown
References: <1318998384-22525-1-git-send-email-tj@kernel.org> <1318998384-22525-11-git-send-email-tj@kernel.org> <4E9EC602.5010207@kernel.dk> <20111019171354.GF25124@google.com>
In-Reply-To: <20111019171354.GF25124@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-19 19:13, Tejun Heo wrote:
> On Wed, Oct 19, 2011 at 02:43:46PM +0200, Jens Axboe wrote:
>> This patch clashes a bit with the previous "fix" for getting rid of
>> privately assigned queue locks. I've kept that single bit.
> 
> Ah, okay, that's the private queue_lock thing Vivek mentioned in the
> earlier reply.  Nice that it's already fixed.

Yep, exactly. I ended up pulling 3.1-rc10 into for-3.2/core to easier
resolve this now.

-- 
Jens Axboe

