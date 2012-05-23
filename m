Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2EWUtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:49:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2EWUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:49:19 -0400
Date: Wed, 23 May 2012 13:49:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 12/16] bcache: Bset code (lookups within a btree
 node)
Message-ID: <20120523204914.GC3933@htj.dyndns.org>
References: <cover.1336619038.git.koverstreet@google.com>
 <5b5998d7d09ec36377acdb5d15665d1e4e818521.1336619038.git.koverstreet@google.com>
 <20120522223932.GK14339@google.com>
 <20120523042114.GC607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523175544.GC18143@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523175544.GC18143@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:55:44AM -0700, Tejun Heo wrote:
> How much benefit are we gaining by doing this float thing?  Any chance
> we can do something simpler?  As long as it's properly encapsulated,
> it shouldn't be too bad but I keep having the suspicion that a lot of
> complexity is added for unnecessary level of optimization.

e.g. how much performance gain does it provide compared to just using
u64 in binary search tree combined with last search result hint for
sequential accesses?

Thanks.

-- 
tejun
