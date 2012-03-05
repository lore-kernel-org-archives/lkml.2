Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2CEQ07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:26:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46930 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2CEQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:26:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.232.106 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 5 Mar 2012 08:26:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20120305162652.GO22536@google.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <20120201163126.GA19837@google.com>
 <20120201184959.GH6731@somewhere.redhat.com>
 <20120201115107.93e11471.akpm@linux-foundation.org>
 <20120202145000.GC9071@somewhere.redhat.com>
 <4F4FFDE4.8050908@free.fr>
 <20120305032130.GD18143@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305032130.GD18143@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Mon, Mar 05, 2012 at 04:21:33AM +0100, Frederic Weisbecker wrote:
> Time for me to try to wake up again this discussion.
> Andrew, Tejun, Li, as you can see we don't lack the users
> for this feature.

Yes, I agree this can be a useful feature for certain use cases.  I'm
just mostly feeling reluctant about adding another utility type
controller without clear direction on how to proceed from here on
regarding multiple hierarchies (and I was on vacation :).  That said,
dealing with multiple hierarchies is a much longer term issue and
we'll probably have to continue on our current path for the time
being.

We're already into -rc6, so unless someone objects I'll try to merge
it after the coming merge window.

Thank you.

-- 
tejun
