Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877Ab1JFMuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 08:50:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1JFMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 08:50:50 -0400
Date: Thu, 6 Oct 2011 07:50:43 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org,
        Balbir Singh <bsingharora@gmail.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: cgroup information proc file format
Message-ID: <20111006125043.GB9894@sergelap>
References: <4E4441C3.5020603@free.fr>
 <4E4449F5.3010909@parallels.com>
 <4E444D96.7080206@free.fr>
 <20110811215238.GC17349@peqn>
 <4E896F18.4010705@parallels.com>
 <20111004024202.GB14469@sergelap>
 <4E8AA508.5000707@parallels.com>
 <20111004140541.GA3619@peqn>
 <4E8C0B89.6020000@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8C0B89.6020000@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Glauber Costa (glommer@parallels.com):
> On 10/04/2011 06:05 PM, Serge Hallyn wrote:
> >Quoting Glauber Costa (glommer@parallels.com):
> >...
> >
> >>>Can't we just introduce the
> >>>/sys/fs/cgroup/memory/memory.proc etc files, and have the procfs code,
> >>>if cgroups are enabled and the task's memory cgroup != '/', return
> >>>the data from that file?
> >>
> >>First: If we're doing that, why do we need that file in the first place?
> >
> >We might not :)  But we might, if we want to offer containers a choice of
> >whether /proc/meminfo is the host's or the container's.
> 
> Hi,
> 
> Please allow me to clarify some points so we are in the same page
> (thus avoiding fragmentation =p )
> 
> Are you quoting /proc/meminfo as an example only, or are you
> concerned specifically with this file? I myself am talking about
> proc files in general.

An example.  But as we are talking in terms of cgroups, I assumed this
was only about procfiles representing resources affected by cgroups -
like /proc/cpuinfo, /proc/meminfo, /proc/devices...

...

> Correct me if I am wrong, but it seems to me now that we agree that
> there should be a mechanism determining whether or not to
> automatically show cgroup-restrained values in proc files.

Agreed.

...

> BTW, A file in each cgroup:
> 
> /sys/fs/cgroup/memory/memory.restrict_proc_data (or any other name)
> /sys/fs/cgroup/cpu/cpu.restrict_proc_data (or any other name)
> etc...
> 
> works for me as well.

Cool.

-serge
