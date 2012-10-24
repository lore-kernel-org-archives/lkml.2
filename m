Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978Ab2JXO3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:29:12 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:47617 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934939Ab2JXO3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:29:10 -0400
Date: Wed, 24 Oct 2012 14:29:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: andi@firstfloor.org
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 1/2] kmem_cache: include allocators code directly into
 slab_common
In-Reply-To: <1351087158-8524-2-git-send-email-glommer@parallels.com>
Message-ID: <0000013a932d456c-8f0cbbce-e3f7-4f2a-b051-7b093a8cfc7e-000000@email.amazonses.com>
References: <1351087158-8524-1-git-send-email-glommer@parallels.com> <1351087158-8524-2-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Glauber Costa wrote:

> Because of that, we either have to move all the entry points to the
> mm/slab.h and rely heavily on the pre-processor, or include all .c files
> in here.

Hmm... That is a bit of a radical solution. The global optimizations now
possible with the new gcc compiler include the ability to fold functions
across different linkable objects. Andi, is that usable for kernel builds?


