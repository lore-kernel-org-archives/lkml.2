Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab1F3P4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:56:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1F3P4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:56:02 -0400
Date: Thu, 30 Jun 2011 17:55:57 +0200
From: Tejun Heo <tj@kernel.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "Seidel, Conny" <Conny.Seidel@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110630155557.GS3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110629123409.GL3386@htj.dyndns.org>
 <20110629125507.GQ478@escobedo.osrc.amd.com>
 <20110629130349.GM3386@htj.dyndns.org>
 <20110629161517.GN3386@htj.dyndns.org>
 <20110630131337.GT478@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630131337.GT478@escobedo.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 30, 2011 at 03:13:38PM +0200, Hans Rosenfeld wrote:
> On Wed, Jun 29, 2011 at 12:15:17PM -0400, Tejun Heo wrote:
> > Hans, can you please apply the following patch and post the boot log
> > from both SPARSEMEM and DISCONTIGMEM kernels?  On SPARSEMEM, it should
> > reject NUMA config and boot w/ flatmem.
> 
> Bootlogs are attached. Now DISCONTIGMEM panics.
...
> [    0.000000] Linux version 2.6.39-rc5-00181-g2706a0b-dirty (root@worms) (gcc version 4.5.2 (Gentoo 4.5.2 p1.1, pie-0.4.5) ) #26 SMP Thu Jun 30 14:39:05 CEST 2011

Hmmm... it looks like the kernel is crashing from the other bug in
this thread.  Can you please apply both patches on top of 3.0-rc5 and
re-test?

Thank you.

-- 
tejun
