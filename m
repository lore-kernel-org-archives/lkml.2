Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752Ab2JXPeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60882 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459Ab2JXPeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:06 -0400
Date: Wed, 24 Oct 2012 17:33:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 1/2] kmem_cache: include allocators code directly into slab_common
Message-ID: <20121024153359.GK16230@one.firstfloor.org>
References: <1351087158-8524-1-git-send-email-glommer@parallels.com> <1351087158-8524-2-git-send-email-glommer@parallels.com> <0000013a932d456c-8f0cbbce-e3f7-4f2a-b051-7b093a8cfc7e-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013a932d456c-8f0cbbce-e3f7-4f2a-b051-7b093a8cfc7e-000000@email.amazonses.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 02:29:09PM +0000, Christoph Lameter wrote:
> On Wed, 24 Oct 2012, Glauber Costa wrote:
> 
> > Because of that, we either have to move all the entry points to the
> > mm/slab.h and rely heavily on the pre-processor, or include all .c files
> > in here.
> 
> Hmm... That is a bit of a radical solution. The global optimizations now
> possible with the new gcc compiler include the ability to fold functions
> across different linkable objects. Andi, is that usable for kernel builds?

Yes, but you need a fairly large patchkit which is not mainline yet.

https://github.com/andikleen/linux-misc/tree/lto

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
