Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2CEQsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:48:42 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62097 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2CEQsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:48:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.52.99.194 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Mon, 5 Mar 2012 17:48:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Aditya Kali <adityakali@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Max Kellermann <mk@cm4all.com>, Tim Hockin <thockin@hockin.org>,
        Glauber Costa <glommer@gmail.com>, Paul Menage <paul@paulmenage.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Containers <containers@lists.linux-foundation.org>,
        Papp =?iso-8859-1?Q?Tam=E1s?= <tompos@martos.bme.hu>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
Message-ID: <20120305164831.GA20996@somewhere.redhat.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <20120201163126.GA19837@google.com>
 <20120201184959.GH6731@somewhere.redhat.com>
 <20120201115107.93e11471.akpm@linux-foundation.org>
 <20120202145000.GC9071@somewhere.redhat.com>
 <4F4FFDE4.8050908@free.fr>
 <20120305032130.GD18143@somewhere.redhat.com>
 <20120305162652.GO22536@google.com>
 <20120305162739.GP22536@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305162739.GP22536@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 08:27:39AM -0800, Tejun Heo wrote:
> On Mon, Mar 05, 2012 at 08:26:52AM -0800, Tejun Heo wrote:
> > Hello, Frederic.
> > 
> > On Mon, Mar 05, 2012 at 04:21:33AM +0100, Frederic Weisbecker wrote:
> > > Time for me to try to wake up again this discussion.
> > > Andrew, Tejun, Li, as you can see we don't lack the users
> > > for this feature.
> > 
> > Yes, I agree this can be a useful feature for certain use cases.  I'm
> > just mostly feeling reluctant about adding another utility type
> > controller without clear direction on how to proceed from here on
> > regarding multiple hierarchies (and I was on vacation :).  That said,
> > dealing with multiple hierarchies is a much longer term issue and
> > we'll probably have to continue on our current path for the time
> > being.
> > 
> > We're already into -rc6, so unless someone objects I'll try to merge
> > it after the coming merge window.

Thanks a lot!

> 
> If I don't take action after the coming -rc1, please ping me.  Thanks.

Sure I will :)
