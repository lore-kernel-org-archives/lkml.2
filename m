Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1HUHVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 03:21:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:50042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1HUHVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 03:21:07 -0400
Date: Sun, 21 Aug 2011 09:19:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        torvalds@linux-foundation.org, liubo2009@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs: fix 64 bit divide problem
Message-ID: <20110821071951.GA4013@kernel.org>
References: <1313843391-3904-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313843391-3904-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Sun, 21 Aug 2011 07:20:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josef Bacik <josef@redhat.com> wrote:

> This fixes a regression introduced by
> 
> cdcb725c05fe0cb71777c66ddc2445fedbbb3c59
> 
> In cases where we need to divide/multiply by 2 we should just left/right shift
> respectively, and in cases where theres N number of devices use do_div.  Also
> make the counters u64 to match up with rw_devices.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Acked-and-tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
