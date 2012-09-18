Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab2IRPWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:22:03 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:16749 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755294Ab2IRPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:22:01 -0400
Date: Tue, 18 Sep 2012 15:22:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 04/16] provide a common place for initcall processing
 in kmem_cache
In-Reply-To: <1347977530-29755-5-git-send-email-glommer@parallels.com>
Message-ID: <00000139d9f8b7b5-31ca6761-b699-49bc-b559-cdcea96b51e8-000000@email.amazonses.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-5-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Glauber Costa wrote:

> Both SLAB and SLUB depend on some initialization to happen when the
> system is already booted, with all subsystems working. This is done
> by issuing an initcall that does the final initialization.
>
> This patch moves that to slab_common.c, while creating an empty
> placeholder for the SLOB.

Acked-by: Christoph Lameter  <cl@linux.com>
