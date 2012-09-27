Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2I0PBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:01:32 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:42625 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435Ab2I0PBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:01:31 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 11:01:31 EDT
Date: Thu, 27 Sep 2012 14:51:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/4] sl[au]b: move print_slabinfo_header to
 slab_common.c
In-Reply-To: <1348756660-16929-3-git-send-email-glommer@parallels.com>
Message-ID: <0000013a08366d0c-86e9d762-0a40-4276-97d1-6ac651847857-000000@email.amazonses.com>
References: <1348756660-16929-1-git-send-email-glommer@parallels.com> <1348756660-16929-3-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Glauber Costa wrote:

> By making sure that information conditionally lives inside a
> globally-visible CONFIG_DEBUG_SLAB switch, we can move the header
> printing to a common location.

Acked-by: Christoph Lameter <cl@linux.com>

