Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab2CMRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:25:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:42815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691Ab2CMRZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:25:57 -0400
Message-ID: <1331659537.18960.84.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>
Date: Tue, 13 Mar 2012 18:25:37 +0100
In-Reply-To: <20120313141032.GD29169@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120312221050.GG23255@google.com> <1331590938.18960.57.camel@twins>
	 <20120312222817.GI23255@google.com> <1331591568.18960.61.camel@twins>
	 <20120312223944.GJ23255@google.com> <1331592241.18960.64.camel@twins>
	 <20120312230416.GM23255@google.com> <20120313141032.GD29169@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 10:10 -0400, Vivek Goyal wrote:
> Implementing hierarchy is a pain and is expensive at run time. 

Yeah, suck it up :-)

I would really rather we mandate one implementation standard for
controllers for the sake of consistency and uniformity. A direct result
of doing away with the multiple hierarchy crap is that all controllers
are co-mounted. Allowing differences like this just doesn't make any
sense.

So either we drop full hierarchy support from all controllers or we
deprecate and remove all non-hierarchical controllers.

I'm fine with either, but I'm not fine with with the half-arsed
solutions proposed here.
