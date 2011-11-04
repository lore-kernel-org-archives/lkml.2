Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1KDNSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:18:36 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:39189 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1KDNSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:18:35 -0400
Message-ID: <4EB3E5F9.80308@free.fr>
Date: Fri, 04 Nov 2011 14:17:45 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mk@cm4all.com,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        nishimura@mxp.nes.nec.co.jp, oleg@redhat.com,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>, tj@kernel.org,
        cgroups@vger.kernel.org, akpm@linux-foundation.org, fweisbec@gmail.com,
        paul@paulmenage.org
Subject: Re: [PATCH] add new cgroup list to CC notice
References: <20111104094030.cf8d5860.kamezawa.hiroyu@jp.fujitsu.com>  <4EB3495B.8080700@free.fr> <1320382250.3108.4.camel@dabdike>
In-Reply-To: <1320382250.3108.4.camel@dabdike>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 05:50 AM, James Bottomley wrote:
> On Fri, 2011-11-04 at 03:09 +0100, Daniel Lezcano wrote:
>> On 11/04/2011 01:40 AM, KAMEZAWA Hiroyuki wrote:
>>> As discussed at Kernel Summit(2011), new cgroups mailing list is opened by
>>> James. This list is for discussing general cgroup design and patches
>>> including all subsystems and for getting more attentions to cgroups/namespaces
>>> related issues by developpers.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>>> ---
>> I don't see the point to unilaterally change the mailing list to
>> vger.kernel.org as the discussions will be  the same as the actual
>> mailing list containers@.
> It's not a unilateral list change.  We will still have containers@lf.
>
> The problem is that not all cgroup related stuff goes over it ...
> particularly the currently active controller discussions tend not to be
> cc'd there.  With systemd (and things like the I/O controllers for
> xen/kvm), cgroups is seen as being wider than containers.
>
> The desire was for a single list where someone could go to get an
> overall view of what's going on in cgroups ... particularly if you're a
> confused subsystem maintainer who just had a request to put a controller
> in your subsystem ...

Ok, thanks for the clarification. May I suggest to create also a 
namespace@ mailing list ?



