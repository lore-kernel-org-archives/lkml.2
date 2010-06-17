Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0FQPje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:39:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0FQPjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:39:33 -0400
Date: Thu, 17 Jun 2010 11:39:24 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: fweisbec <fweisbec@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/14] tracing: add compat syscall support v3
Message-ID: <20100617153924.GD3237@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
 <1274433809-sup-5031@au1.ibm.com>
 <20100521132405.GA2109@redhat.com>
 <1276759528-sup-4850@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276759528-sup-4850@au1.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 05:39:07PM +1000, Ian Munsie wrote:
> Excerpts from Jason Baron's message of Fri May 21 23:24:07 +1000 2010:
> > On Fri, May 21, 2010 at 07:40:21PM +1000, Ian Munsie wrote:
> > > Hi Jason,
> > > 
> > > I'm currently in the process of implementing syscall tracepoints for
> > > PowerPC, and a considerable amount of my work is going to end up
> > > requiring these patches of yours. I've reviewed and tested your patches
> > > (and spent a good chunk of time rebasing them on top of
> > > tip/tracing/core) and they all seem pretty good.
> > > 
> > > I *particularly* like the way in which they prevent ftrace syscalls from
> > > reporting that sys_swapoff was constantly firing on x86_64 kernels with
> > > a 32bit userspace ;)
> > > 
> > > Anyway, I'm just wondering if you have an ETA for the v4 patchset to
> > > address the remaining issues that Frederic raised so that they can be
> > > merged.
> > > 
> > > Cheers,
> > > -Ian
> > > 
> > 
> > hi Ian,
> > 
> > I think the main issue left was that I am using the same meta data for
> > both the 32-bit and 64-bit table entries, when they reference the same
> > syscall. for example, for x86 both the compat and underlying 64-bit
> > kernel reference 'sys_rename'. Thus, i am pointing both perf events at
> > the same meta data. Frederic was saying they need to be separate. I'm
> > not sure i completely understand why, since the 32-bit are just sign
> > extended to 64-bit in this case. Frederic, perhaps, you can explain this
> > a bit more for me?
> > 
> > thanks,
> > 
> > -Jason
> 
> Hi Jason,
> 
> I'm currently cleaning up my patch series for ftrace syscalls on PowerPC
> and want to release it soon.
> 
> It's probably easiest for me if I release your compat syscall support v3
> patches as part of the series. You'd still be marked as the author of
> those commits - the only changes I have made to them was rebasing them
> against the current tip tree and resolving the conflicts that I came
> across.
> 
> Is that OK with you? Otherwise I can wait until you put out the v4
> patches then rebase mine on top of those.
> 

Hi Ian

if its easier for you, that's fine, feel free to include my patches with
your patchset.

thanks,

-Jason
