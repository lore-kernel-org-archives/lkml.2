Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2I0PDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:03:11 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:43905 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533Ab2I0PDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:03:10 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 11:03:10 EDT
Date: Thu, 27 Sep 2012 14:53:42 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/4] slub: move slub internal functions to its header
In-Reply-To: <1348756660-16929-4-git-send-email-glommer@parallels.com>
Message-ID: <0000013a08380e96-c8b9c80e-438a-46c6-b992-67bef9082a41-000000@email.amazonses.com>
References: <1348756660-16929-1-git-send-email-glommer@parallels.com> <1348756660-16929-4-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Glauber Costa wrote:

> The functions oo_order() and oo_objects() are used by the slub to
> determine respectively the order of a candidate allocation, and the
> number of objects made available from it. I would like a stable visible
> location outside slub.c so it can be acessed from slab_common.c.

Patch looks okay but it worries me that we export this internal stuff.

Acked-by: Christoph Lameter <cl@linux.com>
