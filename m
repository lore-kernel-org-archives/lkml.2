Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2ERQS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:18:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59893 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2ERQS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:18:57 -0400
Date: Fri, 18 May 2012 09:18:52 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 07/13] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120518161852.GG19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <04a4d6c2c8b6f0097e3594c6e0932093afffc1da.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04a4d6c2c8b6f0097e3594c6e0932093afffc1da.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:59:54PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> This is prep work for killing bi_destructor

Again, it would be great if the commit message described what
conversion is taking place how and how it's been tested.  Please also
cc the maintainer.

Thanks.

-- 
tejun
