Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0KSDyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:54:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56624 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0KSDyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:54:12 -0500
Date: Thu, 18 Nov 2010 21:54:03 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Kapil Arya <kapil@ccs.neu.edu>,
        Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101119035403.GA24031@hallyn.com>
References: <20101106053204.GB12449@count0.beaverton.ibm.com>
 <20101106204008.GA31077@sundance.ccs.neu.edu>
 <4CD5D99A.8000402@cs.columbia.edu>
 <20101107184927.GF31077@sundance.ccs.neu.edu>
 <4CD72150.9070705@cs.columbia.edu>
 <4CE3C334.9080401@kernel.org>
 <20101117153902.GA1155@hallyn.com>
 <4CE3F8D1.10003@kernel.org>
 <4CE4EE21.6050305@parallels.com>
 <4CE4F672.1030904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE4F672.1030904@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> * And, most of all, there are userland implementation and
>   virtualization, making the benefit to overhead ratio completely off.
>   Userland implementation _already_ achieves most of what's necessary

Guess I'll just be offensive here and say, straight-out:  I don't
believe it.  Can I see the userspace implementation of c/r?

If it's as good as the kernel level c/r, then aweseome - we don't
need the kernel patches.

If it's not as good, then the thing is, we're not drawing arbitrary
lines saying "is this good enough", rather we want completely
reliable and transparent c/r.  IOW, the running task and the other
end can't tell that a migration happened, and, if checkpoint says
it worked, then restart must succeed.

-serge
