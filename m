Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2HOPpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:45:10 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:21146 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621Ab2HOPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:45:08 -0400
Date: Wed, 15 Aug 2012 15:45:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] slub: try to get cpu partial slab even if we get enough
 objects for cpu freelist
In-Reply-To: <1345045084-7292-1-git-send-email-js1304@gmail.com>
Message-ID: <000001392af5ab4e-41dbbbe4-5808-484b-900a-6f4eba102376-000000@email.amazonses.com>
References: <1345045084-7292-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Joonsoo Kim wrote:

> s->cpu_partial determine the maximum number of objects kept
> in the per cpu partial lists of a processor. Currently, it is used for
> not only per cpu partial list but also cpu freelist. Therefore
> get_partial_node() doesn't work properly according to our first intention.

The "cpu freelist" in slub is the number of free objects in a specific
page. There is nothing that s->cpu_partial can do about that.

Maybe I do not understand you correctly. Could you explain this in some
more detail?
