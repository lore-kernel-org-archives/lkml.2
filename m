Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2JQWM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:12:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2JQWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:12:55 -0400
Date: Wed, 17 Oct 2012 15:12:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 14/14] Add documentation about the kmem controller
Message-Id: <20121017151254.e26607c5.akpm@linux-foundation.org>
In-Reply-To: <1350382611-20579-15-git-send-email-glommer@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
	<1350382611-20579-15-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 14:16:51 +0400
Glauber Costa <glommer@parallels.com> wrote:

> +Kernel memory won't be accounted at all until limit on a group is set. This
> +allows for existing setups to continue working without disruption.  The limit
> +cannot be set if the cgroup have children, or if there are already tasks in the
> +cgroup.

What behaviour will usersapce see if "The limit cannot be set"? 
write() returns -EINVAL, something like that?

