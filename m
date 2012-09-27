Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2I0SDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:03:23 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:45105 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab2I0SDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:03:22 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:03:21 EDT
Date: Thu, 27 Sep 2012 17:53:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 4/4] sl[au]b: process slabinfo_show in common code
In-Reply-To: <506480FB.40802@parallels.com>
Message-ID: <0000013a08dd105c-06e1ed72-defd-4e0e-aee6-89f6244328f0-000000@email.amazonses.com>
References: <1348756660-16929-1-git-send-email-glommer@parallels.com> <1348756660-16929-5-git-send-email-glommer@parallels.com> <0000013a08443b02-5715bfe6-9c47-49c5-a951-8a48cc432e42-000000@email.amazonses.com> <506480FB.40802@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Glauber Costa wrote:

> Yes. As a matter of fact, I first implemented it this way, and later
> switched. I was anticipating that people would be likely to point out
> that those properties are directly derivable from the caches, and it
> would be better to just get them from there.

That is not the case if the information is packet as in the case of SLUB.

SLOB (which at some point also could be supported) has an altogether
different way of arranging objects in pagbes.


