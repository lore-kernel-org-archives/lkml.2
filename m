Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2CASD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:03:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55670 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2CASDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:03:25 -0500
Message-ID: <1330624986.11248.209.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Thu, 01 Mar 2012 19:03:06 +0100
In-Reply-To: <4F4FAF89.3090706@redhat.com>
References: <20120221211938.GE12236@google.com>
	  <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	  <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	 <4F4FAF89.3090706@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 18:19 +0100, Michal Schmidt wrote:
> Dne 23.2.2012 15:13, Peter Zijlstra napsal:
> > My utter disregard for cgroups comes from having to actually implement a
> > controller for them, its a frigging nightmare. The systemd retards
> > mandating all this nonsense for booting a machine is completely bonghit
> > inspired and hasn't made me feel any better about it.
> 
> systemd requires only CONFIG_CGROUPS=y. It does not need any controllers.

And that makes it better how?

> The insults are entirely unnecessary.

I think not, booting a machine should depend on the smallest possible
subset of features. Doing anything else is completely bonkers.

Luckily it looks like the Debian guys made the right decision -- albeit
for the wrong reasons.

