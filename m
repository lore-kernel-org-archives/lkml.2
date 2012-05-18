Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab2ERQQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:16:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64795 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2ERQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:16:13 -0400
Date: Fri, 18 May 2012 09:16:08 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 06/13] block: Add bio_reset()
Message-ID: <20120518161608.GF19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 17, 2012 at 10:59:53PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> Reusing bios is something that's been highly frowned upon in the past,
> but driver code keeps doing it anyways. If it's going to happen anyways,
> we should provide a generic method.
> 
> This'll help with getting rid of bi_destructor.

It would be nice to explain a bit why this helps bi_destructor
removal.

> +#define BIO_RESET_OFFSET	offsetof(struct bio, bi_max_vecs)

Maybe better named BIO_RESET_BYTES?  As offset tends to indicate the
start of a region.

Thanks.

-- 
tejun
