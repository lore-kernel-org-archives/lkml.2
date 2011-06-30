Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1F3QmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:42:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1F3QmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:42:20 -0400
Date: Thu, 30 Jun 2011 18:42:16 +0200
From: Tejun Heo <tj@kernel.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "Seidel, Conny" <Conny.Seidel@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110630164216.GU3386@htj.dyndns.org>
References: <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110629123409.GL3386@htj.dyndns.org>
 <20110629125507.GQ478@escobedo.osrc.amd.com>
 <20110629130349.GM3386@htj.dyndns.org>
 <20110629161517.GN3386@htj.dyndns.org>
 <20110630131337.GT478@escobedo.osrc.amd.com>
 <20110630155557.GS3386@htj.dyndns.org>
 <20110630163227.GU478@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630163227.GU478@escobedo.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 30, 2011 at 06:32:28PM +0200, Hans Rosenfeld wrote:
> On Thu, Jun 30, 2011 at 11:55:57AM -0400, Tejun Heo wrote:
> > Hmmm... it looks like the kernel is crashing from the other bug in
> > this thread.  Can you please apply both patches on top of 3.0-rc5 and
> > re-test?
> 
> Oh, thats why it looked so familiar :)
> 
> I wasn't able to reproduce this panic on this machine earlier without
> DISCONTIGMEM.
> 
> It works now with both patches, bootlog is attached.

Can you please attach boot log w/ SPARSEMEM?  Let's see whether NUMA
config is being rejected correctly.

Thanks.

-- 
tejun
