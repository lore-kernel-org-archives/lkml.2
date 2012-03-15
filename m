Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031371Ab2COAYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:24:01 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38083 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760605Ab2COAYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:24:00 -0400
Date: Wed, 14 Mar 2012 17:23:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, akpm@linux-foundation.org,
        rob.lee@linaro.org, j-pihet@ti.com, khilman@ti.com,
        deepthi@linux.vnet.ibm.com, dan.carpenter@oracle.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org
Subject: Re: [PATCH] cpuidle : fix random hangs with intel_idle
In-Reply-To: <20120315111415.cd119171ac86967aebe85545@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.1203141720360.2003@eggly.anvils>
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils> <1331770181-800-1-git-send-email-daniel.lezcano@linaro.org> <20120315111415.cd119171ac86967aebe85545@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Stephen Rothwell wrote:
> On Thu, 15 Mar 2012 01:09:41 +0100 Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> >
> > The cpuidle consolidation inverts the local_irq_enable for
> > the poll_idle function with CPU_RELAX.
> > 
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Reported-by: Hugh Dickins <hughd@google.com>
> 
> So this needs to go into Rob's tree.  Maybe after Hugh verifies that it
> fixes his problem.

Yes, Daniel got me to try it offline before he posted it.

Tested-by: Hugh Dickins <hughd@google.com>

Personally, I'd recommend including it even before it gets into Rob's
tree (where it may well be improved upon first): it does a lot to
improve the usability of linux-next.

Hugh
