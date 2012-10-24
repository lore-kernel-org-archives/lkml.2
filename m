Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab2JXGnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:43:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61434 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab2JXGnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <1350656442-1523-2-git-send-email-glommer@parallels.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
	<1350656442-1523-2-git-send-email-glommer@parallels.com>
Date: Wed, 24 Oct 2012 09:43:09 +0300
X-Google-Sender-Auth: PucGCVwG5sEkcCsbH1kx8g-iNO4
Message-ID: <CAOJsxLFuHVKSnpN=+-7Z-C0mNgYu_pnS0jJgUmDkoPkdkgDteQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/18] move slabinfo processing to slab_common.c
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>, devel@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 5:20 PM, Glauber Costa <glommer@parallels.com> wrote:
> This patch moves all the common machinery to slabinfo processing
> to slab_common.c. We can do better by noticing that the output is
> heavily common, and having the allocators to just provide finished
> information about this. But after this first step, this can be done
> easier.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: David Rientjes <rientjes@google.com>

I've applied patches 1-3. Thanks, Glauber!
