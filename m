Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2FNJ7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:59:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33495 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab2FNJ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:59:30 -0400
Date: Thu, 14 Jun 2012 11:59:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/6] x86/x2apic/cluster: vector_allocation_domain()
 should return a value
Message-ID: <20120614095925.GA19531@gmail.com>
References: <cover.1339657103.git.agordeev@redhat.com>
 <20120614074913.GD3383@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614074913.GD3383@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> Since 5a48cd5 vector_allocation_domain() indicates if a cpumask is
> dynamic or static. This update fixes the oversight and makes the
> operation to return a value.

There's no commit 5a48cd5 in -tip. Please use such notations to 
refer to specific commits:

  Since commit 5a48cd5 ("apic: Foo, bar") ...

so that we can figure out the dependency and where the commit 
is.

Thanks,

	Ingo
