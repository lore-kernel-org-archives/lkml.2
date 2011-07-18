Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1GRRJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:09:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37244 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1GRRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:09:54 -0400
Date: Mon, 18 Jul 2011 19:09:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
Message-ID: <20110718170950.GD8006@one.firstfloor.org>
References: <1310987909-3129-1-git-send-email-amwang@redhat.com> <CAOJsxLHuqvVEKg84jmRW_yfLic9ytB8GzeAE4YWauxSWryHGzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLHuqvVEKg84jmRW_yfLic9ytB8GzeAE4YWauxSWryHGzA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 03:14:18PM +0300, Pekka Enberg wrote:
> On Mon, Jul 18, 2011 at 2:18 PM, Amerigo Wang <amwang@redhat.com> wrote:
> > On ppc, we got this build error with randconfig:
> >
> > drivers/built-in.o:(.toc1+0xf90): undefined reference to `vmstat_text': 1 errors in 1 logs
> >
> > This is due to that it enabled CONFIG_NUMA but not CONFIG_SYSFS.
> >
> > And the user-space tool numactl depends on sysfs files too.
> > So, I think it is very reasonable to make CONFIG_NUMA depend on CONFIG_SYSFS.
> 
> Is it? CONFIG_NUMA is useful even without userspace numactl tool, no?

Yes it is. No direct dependency.

I would rather fix it in ppc.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
