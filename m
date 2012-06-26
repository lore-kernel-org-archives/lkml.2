Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab2FZFak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:30:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2FZFai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:30:38 -0400
Date: Mon, 25 Jun 2012 22:31:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
Message-Id: <20120625223136.86ebee05.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1206252224350.30072@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-10-git-send-email-glommer@parallels.com>
	<20120625162352.51997c5a.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1206252224350.30072@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 22:24:44 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> > > +#define KMEM_ACCOUNTED_THIS	0
> > > +#define KMEM_ACCOUNTED_PARENT	1
> > 
> > And then document the fields here.
> > 
> 
> In hex, please?

Well, they're bit numbers, not masks.  Decimal 0-31 is OK, or an enum.
