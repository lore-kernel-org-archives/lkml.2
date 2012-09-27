Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2I0O7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:59:44 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:41340 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab2I0O7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:59:43 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 10:59:43 EDT
Date: Thu, 27 Sep 2012 14:50:14 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/4] sl[au]b: move slabinfo processing to slab_common.c
In-Reply-To: <1348756660-16929-2-git-send-email-glommer@parallels.com>
Message-ID: <0000013a0834e0d6-20316779-0961-45a0-ae69-3e41ea466137-000000@email.amazonses.com>
References: <1348756660-16929-1-git-send-email-glommer@parallels.com> <1348756660-16929-2-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Glauber Costa wrote:

> This patch moves all the common machinery to slabinfo processing
> to slab_common.c. We can do better by noticing that the output is
> heavily common, and having the allocators to just provide finished
> information about this. But after this first step, this can be done
> easier.

Acked-by: Christoph Lameter <cl@linux.com>
