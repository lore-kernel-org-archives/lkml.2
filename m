Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2F1WZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:25:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab2F1WZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:25:42 -0400
Date: Thu, 28 Jun 2012 15:25:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: David Rientjes <rientjes@google.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Rik van Riel <riel@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Kir Kolyshkin <kir@parallels.com>
Subject: Re: Fork bomb limitation in memcg WAS: Re: [PATCH 00/11] kmem
 controller for memcg: stripped down version
Message-Id: <20120628152540.cc13a735.akpm@linux-foundation.org>
In-Reply-To: <4FEC1D63.6000903@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<20120625162745.eabe4f03.akpm@linux-foundation.org>
	<4FE9621D.2050002@parallels.com>
	<20120626145539.eeeab909.akpm@linux-foundation.org>
	<4FEAD260.4000603@parallels.com>
	<alpine.DEB.2.00.1206271233080.22162@chino.kir.corp.google.com>
	<4FEC1D63.6000903@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 13:01:23 +0400
Glauber Costa <glommer@parallels.com> wrote:

>
> ...
>

OK, that all sounds convincing ;) Please summarise and capture this
discussion in the [patch 0/n] changelog so we (or others) don't have to
go through this all again.  And let's remember this in the next
patchset!

> Last, but not least, note that it is totally within my interests to
> merge the slab tracking as fast as we can. it'll be a matter of going
> back to it, and agreeing in the final form.

Yes, I'd very much like to have the whole slab implementation in a
reasonably mature state before proceeding too far with this base
patchset.

