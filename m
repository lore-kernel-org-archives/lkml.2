Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2INJE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:04:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50300 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753775Ab2INJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:04:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18q0NFd7o4qnKYjI5piFYw16GifQDppsoagsCTHnd
	LtFJVl9BzaBgD1
Message-ID: <1347613484.4340.132.camel@marge.simpson.net>
Subject: Re: [RFC] cgroup TODOs
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 11:04:44 +0200
In-Reply-To: <20120913205827.GO7677@google.com>
References: <20120913205827.GO7677@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 13:58 -0700, Tejun Heo wrote:

> 7. Misc issues
> 
   * Extract synchronize_rcu() from user interface?  Exporting grace
periods to userspace isn't wonderful for dynamic launchers.

-Mike

