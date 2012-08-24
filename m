Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab2HXQbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:31:09 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:38242 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932403Ab2HXQbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:31:05 -0400
Date: Fri, 24 Aug 2012 16:31:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] slub: correct the calculation of the number of cpu
 objects in get_partial_node
In-Reply-To: <CAAmzW4ORnSLMdhVPmYPpeEJ=P1rrpz1LOibOYWQJgOYQxmDhuA@mail.gmail.com>
Message-ID: <000001395978f794-7569c405-1955-4e20-ad74-6e60ee4efcdc-000000@email.amazonses.com>
References: <1345824303-30292-1-git-send-email-js1304@gmail.com> <1345824303-30292-2-git-send-email-js1304@gmail.com> <00000139596a800b-875d7863-23ac-44a5-8710-ea357f3df8a8-000000@email.amazonses.com>
 <CAAmzW4ORnSLMdhVPmYPpeEJ=P1rrpz1LOibOYWQJgOYQxmDhuA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012, JoonSoo Kim wrote:

> But, when using "cpu_partial_objects", I have a coding style problem.
>
>                 if (kmem_cache_debug(s)
>                         || cpu_slab_objects + cpu_partial_objects
>                                                 > s->max_cpu_object / 2)
>
> Do you have any good idea?

Not sure what the problem is? The line wrap?

Reduce the tabs for the third line?

