Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0JTHb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:31:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44823 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0JTHb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:31:57 -0400
Date: Wed, 20 Oct 2010 09:31:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [PATCH 2/2]x86: spread tlb flush vector between nodes
Message-ID: <20101020073155.GB20124@basil.fritz.box>
References: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
 <1287551797.2700.76.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287551797.2700.76.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe we should have a per_node memory infrastructure, so that we can
> lower memory needs of currently per_cpu objects.

I have been looking at that :- for a lot of things per core
data makes sense too.

Really a lot of the per CPU scaling we have today should be per core
or per node to avoid explosion.

But for this particular case it doesn't help because you still
need a mapping for each CPU.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
