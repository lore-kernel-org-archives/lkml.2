Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab2CLWoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:44:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2CLWoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:44:20 -0400
Message-ID: <1331592241.18960.64.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Date: Mon, 12 Mar 2012 23:44:01 +0100
In-Reply-To: <20120312223944.GJ23255@google.com>
References: <20120221211938.GE12236@google.com>
	 <20120312221050.GG23255@google.com> <1331590938.18960.57.camel@twins>
	 <20120312222817.GI23255@google.com> <1331591568.18960.61.camel@twins>
	 <20120312223944.GJ23255@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 15:39 -0700, Tejun Heo wrote:
> If we can get to the point where nesting is fully
> supported by every controller first, that would be awesome too. 

As long as that is the goal.. otherwise, I'd be overjoyed if I can rip
nesting support out of the cpu-controller.. that stuff is such a pain.
Then again, I don't think the container people like this proposal --
they were the ones pushing for full hierarchy back when.

Another way there is simply deprecating and removing all
non-hierarchical controllers (and not adding any more while we're at
it).
