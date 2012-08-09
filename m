Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2HIG45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:56:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36275 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2HIG44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:56:56 -0400
Date: Wed, 8 Aug 2012 23:56:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH] Consolidate bio_clone_bioset(), bio_kmalloc()
Message-ID: <20120809065650.GF2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-11-git-send-email-koverstreet@google.com>
 <20120808231552.GJ6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809023811.GJ7262@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809023811.GJ7262@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 07:38:11PM -0700, Kent Overstreet wrote:
> So here's my initial stab at it. Tell me if you think this is too
> contorted:

At the first glance, looks okay to me.

Thanks.

-- 
tejun
