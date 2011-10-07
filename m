Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935385Ab1JGHtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:49:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51296 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1JGHtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:49:21 -0400
Date: Fri, 7 Oct 2011 00:49:04 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com,
        Biederman Eric Biederman <ebiederm@xmission.com>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111007074904.GC16723@count0.beaverton.ibm.com>
References: <1317943022.1095.25.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317943022.1095.25.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11100707-5112-0000-0000-000000DA08DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 01:17:02AM +0200, Kay Sievers wrote:

<snip>

> * simple, reliable and future-proof way to detect whether a specific pid
> is running in a CLONE_NEWPID container, i.e. not in the root PID
> namespace. Currently, there are available a few ugly hacks to detect

Is that precisely what's needed or would it be sufficient to know
that the pid is running in a child pid namespace of the current pid
namespace? If so, I think this could eventually be done by comparing
the inode numbers assigned to /proc/<pid>/ns/pid to those of
/proc/1/ns/pid.

> * Add a timerslack cgroup controller, to allow increasing the timer
> slack of user session cgroups when the machine is idle.

There were patches for a timerslack cgroup controller but for some
reason (I don't recall why) they stalled. It might be worth digging
through the containers mailing list archives.

Cheers,
	-Matt Helsley

