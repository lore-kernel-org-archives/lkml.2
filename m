Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab1KWDkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:40:55 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59307 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1KWDkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:40:53 -0500
Date: Tue, 22 Nov 2011 22:40:39 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm tree with the net-next tree
Message-ID: <20111123034039.GB17298@neilslaptop.think-freely.org>
References: <20111123142742.9b4fb79fd3748325753a896a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123142742.9b4fb79fd3748325753a896a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 02:27:42PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm got a conflict in
> include/linux/cgroup_subsys.h between commit 5bc1421e34ec ("net: add
> network priority cgroup infrastructure (v4)") from the net-next tree and
> commit 22a20a26f21c ("cgroups: add a task counter subsystem") from the
> akpm tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.
ACK, thanks Stephen.
Neil


