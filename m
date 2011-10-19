Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab1JSROB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:14:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50977 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab1JSRN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:13:58 -0400
Date: Wed, 19 Oct 2011 10:13:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCH 10/10] block: fix request_queue lifetime handling by
 making blk_queue_cleanup() proper shutdown
Message-ID: <20111019171354.GF25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-11-git-send-email-tj@kernel.org>
 <4E9EC602.5010207@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9EC602.5010207@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 02:43:46PM +0200, Jens Axboe wrote:
> This patch clashes a bit with the previous "fix" for getting rid of
> privately assigned queue locks. I've kept that single bit.

Ah, okay, that's the private queue_lock thing Vivek mentioned in the
earlier reply.  Nice that it's already fixed.

Thanks.

-- 
tejun
