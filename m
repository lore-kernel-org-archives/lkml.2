Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672Ab2B1VV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:21:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:56096 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2B1VVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:21:55 -0500
Message-ID: <1330464100.11248.94.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Tue, 28 Feb 2012 22:21:40 +0100
In-Reply-To: <20120228211627.GH9920@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <20120223213847.GK19691@redhat.com>
	 <20120223223457.GJ22536@google.com> <20120228211627.GH9920@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 16:16 -0500, Vivek Goyal wrote:
> 
> But in this case, if task and groups are treated at same level, things
> are not static and % share will change dynamically. 

which is exactly how the scheduler stuff behaves for the proportional
bits.. so there's no reason not to do it too.


