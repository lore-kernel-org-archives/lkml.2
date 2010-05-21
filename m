Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab0EUQJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:09:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:57070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007Ab0EUQJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,279,1272870000"; 
   d="scan'208";a="623699894"
Subject: Re: [PATCH 0/2] tmpfs: Improve tmpfs scalability
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.1005201837040.21050@tigran.mtv.corp.google.com>
References: <1274225666.31973.8949.camel@mudge.jf.intel.com>
	 <alpine.DEB.1.00.1005201837040.21050@tigran.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 09:07:47 -0700
Message-ID: <1274458067.31973.8955.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 18:55 -0700, Hugh Dickins wrote:

> 
> Interesting, thank you - I'll take a look, but not this week.
> 
> I do hope you're using Aim7 just as an example: you know that mounting
> tmpfs with nr_blocks=0,nr_inodes=0 skips those shmem_sb_info updates
> altogether?  Mounting in such a way should be fine for getting better
> numbers out of Aim7; but yes, there are reallife uses for tmpfs which
> are safer with the nr_blocks,nr_inodes limits.
> 

Yes, Aim7 was provided as an example to illustrate the locking
bottleneck when blocks limit are imposed.

Tim


