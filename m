Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab2BWONi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:13:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:42821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2BWONh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:13:37 -0500
Message-ID: <1330006399.11248.20.camel@twins>
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
Date: Thu, 23 Feb 2012 15:13:19 +0100
In-Reply-To: <1329990094.24994.64.camel@twins>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 10:41 +0100, Peter Zijlstra wrote:
> If your complete control is % based then I would assume its a % of a %.
> Simple enough.
> 
> If its bandwidth based then simply don't allow a child to consume more
> bandwidth than its parent, also simple.
> 
> If your layman isn't capable of grokking that, he should stay the f*ck
> away from it. 

Fact is, the scheduler does both these things, so there's absolutely no
reason for other controllers not to do so too. Its the only sensible
thing if you want hierarchy.

My utter disregard for cgroups comes from having to actually implement a
controller for them, its a frigging nightmare. The systemd retards
mandating all this nonsense for booting a machine is completely bonghit
inspired and hasn't made me feel any better about it.


