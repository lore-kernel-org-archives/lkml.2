Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2IPITa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 04:19:30 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44657 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008Ab2IPIT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 04:19:26 -0400
Message-ID: <1347783557.2463.1.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] cgroup TODOs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Sun, 16 Sep 2012 09:19:17 +0100
In-Reply-To: <20120914183641.GA2191@cathedrallabs.org>
References: <20120913205827.GO7677@google.com>
	 <20120914183641.GA2191@cathedrallabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 14:36 -0400, Aristeu Rozanski wrote:
> also, heard about the desire of having a device namespace instead with
> support for translation ("sda" -> "sdf"). If anyone see immediate use for
> this please let me know.

That sounds like a really bad idea to me.  We've spent ages training
users that the actual sd<x> name of their device doesn't matter and they
should use UUIDs or WWNs instead ... why should they now care inside
containers?

James




