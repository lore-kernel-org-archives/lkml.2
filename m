Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2JASAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:00:25 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:7976 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab2JASAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:00:24 -0400
Date: Mon, 1 Oct 2012 18:00:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] slab: Ignore internal flags in cache creation
In-Reply-To: <1349088458-3940-1-git-send-email-glommer@parallels.com>
Message-ID: <0000013a1d7c65d7-e63e5171-d5ea-4464-a5ea-c345d6804c07-000000@email.amazonses.com>
References: <1349088458-3940-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Glauber Costa wrote:

> [ v2: leave the mask out decision up to the allocators ]

Acked-by: Christoph Lameter <cl@linux.com>

I would prefer that this mask be named appropriately and be defined in all
sl*_def.h files for all allocators.

Name could be SLAB_AVAILABLE_FLAGS or some name that makes more
sense than CACHE_CREATE_MASK.

