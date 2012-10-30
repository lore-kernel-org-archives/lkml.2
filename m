Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2J3Pbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:31:53 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:5987 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756883Ab2J3Pbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:31:52 -0400
Date: Tue, 30 Oct 2012 15:31:51 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: andi@firstfloor.org
cc: Pekka Enberg <penberg@kernel.org>, Glauber Costa <glommer@parallels.com>,
        linux-mm@kvack.org, JoonSoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 1/2] kmem_cache: include allocators code directly into
 slab_common
In-Reply-To: <CAAmzW4O1EAFxHf1tRaFzg-opPLzMboAdo-vbUFkyo=ZdQp9rmw@mail.gmail.com>
Message-ID: <0000013ab24cd7ac-1c5345d6-5fea-4459-942e-b6deccd1a6f1-000000@email.amazonses.com>
References: <1351087158-8524-1-git-send-email-glommer@parallels.com> <1351087158-8524-2-git-send-email-glommer@parallels.com> <CAOJsxLHxo7zJk=aWrjmuaYsEkaChTCgXowtHxtuiabaOP3W3-Q@mail.gmail.com> <0000013a9444c6ba-d26e7627-1890-40da-ae91-91e7c4a3d7e9-000000@email.amazonses.com>
 <CAAmzW4O1EAFxHf1tRaFzg-opPLzMboAdo-vbUFkyo=ZdQp9rmw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, JoonSoo Kim wrote:

> 2012/10/25 Christoph Lameter <cl@linux.com>:
> > On Wed, 24 Oct 2012, Pekka Enberg wrote:
> >
> >> So I hate this patch with a passion. We don't have any fastpaths in
> >> mm/slab_common.c nor should we. Those should be allocator specific.
> >
> > I have similar thoughts on the issue. Lets keep the fast paths allocator
> > specific until we find a better way to handle this issue.
>
> Okay. I see.
> How about applying LTO not to the whole kernel code, but just to
> slab_common.o + sl[aou]b.o?
> I think that it may be possible, isn't it?

Well.... Andi: Is that possible?
