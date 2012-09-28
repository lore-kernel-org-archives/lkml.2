Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2I1ORW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:17:22 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:45151 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758025Ab2I1ORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:17:19 -0400
Date: Fri, 28 Sep 2012 14:17:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] slub: init_kmem_cache_cpus() and put_cpu_partial() can
 be static
In-Reply-To: <20120928083405.GA23740@localhost>
Message-ID: <0000013a0d3d1629-ffd18aa2-add5-487c-9897-45f14fcbef32-000000@email.amazonses.com>
References: <20120928083405.GA23740@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Fengguang Wu wrote:

> Acked-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Christoph Lameter <cl@linux.com>
