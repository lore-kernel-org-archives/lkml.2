Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2CBLQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:16:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143Ab2CBLQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:16:19 -0500
Message-ID: <4F50ABF2.5070809@redhat.com>
Date: Fri, 02 Mar 2012 12:16:02 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com>  <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>  <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>  <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>
In-Reply-To: <1330633603.7414.49.camel@marge.simpson.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 09:26 PM, Mike Galbraith wrote:
> Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
> over sysvinits job afaiui, what does that have to do with cgroups?

It does more than sysvinit. It does more than fork off services and then 
forget about them. It keeps track of them all the time.
It notices when all processes of a service have exited.
It can kill all processes descended from a service.
It can always tell what service a given process belongs to.

Michal
