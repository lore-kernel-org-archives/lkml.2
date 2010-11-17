Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab0KQAuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:50:46 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44982 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab0KQAuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:50:44 -0500
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Tue, 16 Nov 2010 16:50:40 -0800
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/28] fs: change d_hash for rcu-walk
Message-ID: <20101117005040.GC22789@tpepper-t61p.dolavim.us>
References: <20101116140900.039761100@kernel.dk>
 <20101116142028.938211454@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116142028.938211454@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17 Nov at 01:09:08 +1100 npiggin@kernel.dk said:
> Change d_hash so it may be called from lock-free RCU lookups. See similar
> patch for d_compare for details.
> 
> For in-tree filesystems, this is just a mechanical change.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> ---
>  Documentation/filesystems/Locking |    5 +++--
>  Documentation/filesystems/porting |    7 +++++++
>  Documentation/filesystems/vfs.txt |    8 ++++++--
>  fs/dcache.c                       |    2 +-
>  include/linux/dcache.h            |    3 ++-

And maybe I'm lazy or something, but it seems like it'd make the reviewing
easier if the above core hunks were formatted in the email before/above
the pages and pages of per fs changes.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
