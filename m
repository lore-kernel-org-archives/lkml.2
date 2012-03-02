Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2CBLZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:25:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34044 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2CBLZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:25:07 -0500
Message-ID: <1330687491.11248.223.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Fri, 02 Mar 2012 12:24:51 +0100
In-Reply-To: <4F50ABF2.5070809@redhat.com>
References: <20120221211938.GE12236@google.com>
	  <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	  <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	  <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>
	 <4F50ABF2.5070809@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 12:16 +0100, Michal Schmidt wrote:
> On 03/01/2012 09:26 PM, Mike Galbraith wrote:
> > Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
> > over sysvinits job afaiui, what does that have to do with cgroups?
> 
> It does more than sysvinit. It does more than fork off services and then 
> forget about them. It keeps track of them all the time.
> It notices when all processes of a service have exited.
> It can kill all processes descended from a service.
> It can always tell what service a given process belongs to.

And I don't give a crap about any of that.. sysvinit was sufficient. 
