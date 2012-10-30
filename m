Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab2J3U16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:27:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37765 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab2J3U15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:27:57 -0400
Date: Tue, 30 Oct 2012 21:27:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: andi@firstfloor.org, Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        JoonSoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 1/2] kmem_cache: include allocators code directly into slab_common
Message-ID: <20121030202750.GW16230@one.firstfloor.org>
References: <1351087158-8524-1-git-send-email-glommer@parallels.com> <1351087158-8524-2-git-send-email-glommer@parallels.com> <CAOJsxLHxo7zJk=aWrjmuaYsEkaChTCgXowtHxtuiabaOP3W3-Q@mail.gmail.com> <0000013a9444c6ba-d26e7627-1890-40da-ae91-91e7c4a3d7e9-000000@email.amazonses.com> <CAAmzW4O1EAFxHf1tRaFzg-opPLzMboAdo-vbUFkyo=ZdQp9rmw@mail.gmail.com> <0000013ab24cd7ac-1c5345d6-5fea-4459-942e-b6deccd1a6f1-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ab24cd7ac-1c5345d6-5fea-4459-942e-b6deccd1a6f1-000000@email.amazonses.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 03:31:51PM +0000, Christoph Lameter wrote:
> On Fri, 26 Oct 2012, JoonSoo Kim wrote:
> 
> > 2012/10/25 Christoph Lameter <cl@linux.com>:
> > > On Wed, 24 Oct 2012, Pekka Enberg wrote:
> > >
> > >> So I hate this patch with a passion. We don't have any fastpaths in
> > >> mm/slab_common.c nor should we. Those should be allocator specific.
> > >
> > > I have similar thoughts on the issue. Lets keep the fast paths allocator
> > > specific until we find a better way to handle this issue.
> >
> > Okay. I see.
> > How about applying LTO not to the whole kernel code, but just to
> > slab_common.o + sl[aou]b.o?
> > I think that it may be possible, isn't it?
> 
> Well.... Andi: Is that possible?

In principle yes, but would still need a toolchain with LTO 
support and a few changes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
