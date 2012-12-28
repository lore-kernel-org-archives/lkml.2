Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2L1VwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:52:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58224 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2L1VwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:52:20 -0500
Subject: Re: [PATCH v2] lib: cpu_rmap: avoid flushing all workqueues
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Decotigny <decot@googlers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <CAG88wWbPY76O1YOSb=Jp2hGhQEgSDLoseorkTjOcep3pj1Z1bA@mail.gmail.com>
References: <cover.1356721114.git.decot@googlers.com>
	 <d1d3f42dff1837cd43e67f954c51eb9d1f91b4ba.1356721114.git.decot@googlers.com>
	 <1356729284.21409.889.camel@edumazet-glaptop>
	 <CAG88wWbPY76O1YOSb=Jp2hGhQEgSDLoseorkTjOcep3pj1Z1bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Dec 2012 13:52:17 -0800
Message-ID: <1356731537.21409.1002.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 13:44 -0800, David Decotigny wrote:
> Thanks,
> 
> Ok for the cpu_rmap_put helper. Will do this in v3 of this patch.
> 
> Your comments suggest more refactoring, which might be better in the
> form of 1 or 2 additional patches that:
>  - rename alloc_cpu_rmap & co according to new conventions (cpu_rmap_*)
>  - remove the cpu_rmap sub-API altogether, keeping only irq_cpu_rmap
> (controversial?)
> 
> I'd rather current patch is integrated in its own as it fixes an actual bug.
> I will send the other patch(es) separately later.

This looks fine to me !


