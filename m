Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1JYHyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:54:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:25110 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab1JYHys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,403,1315206000"; 
   d="scan'208";a="81438679"
Date: Tue, 25 Oct 2011 09:54:35 +0200
From: Andi Kleen <ak@linux.intel.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/24] GFS2: Fix lseek after SEEK_DATA, SEEK_HOLE have
 been added
Message-ID: <20111025075435.GA5325@alboin.Mikenopa.local>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
 <1319460518-9046-10-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319460518-9046-10-git-send-email-swhiteho@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 01:48:23PM +0100, Steven Whitehouse wrote:
> We need to take the inode's glock whenever the inode's size
> is referenced, otherwise it might not be uptodate. Even
> though generic_file_llseek_unlocked() doesn't implement
> SEEK_DATA, SEEK_HOLE directly, it does reference the inode's
> size in those cases, so we need to add them to the list
> of origins which need the glock.
> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>

Looks good.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
