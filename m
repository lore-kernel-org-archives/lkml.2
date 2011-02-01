Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1BASlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:41:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1BASlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:41:39 -0500
Date: Tue, 1 Feb 2011 13:41:10 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Message-ID: <20110201184110.GB21209@redhat.com>
References: <20110201162703.2284.qmail@science.horizon.com>
 <4D484853.9020409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D484853.9020409@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 08:52:19PM +0300, Cyrill Gorcunov wrote:
> On 02/01/2011 07:27 PM, George Spelvin wrote:
> > Since upgrading to -rc2 (-rc3 is compiling right now), I've been getting
> > complaints at irregular intervals.  This didn't used to happen with 2.6.37.
> > 
> ...
> > Should I bisect this, or does someone know what might be happening?
> > 
> > Thank you!
> > 
> 
>  I fear it's known issue at moment, we're trying to resolve it. There is
> an option -- to disable nmi_watchdog (nmi_watchdog=0 boot option).
> 
>  But if you have a will or would like to help debug the problem -- mind to
> try the patch below? Note the patch is ugly at moment and must *not* be
> running on non-P4 system (and I only compile-tested it so no guarantees
> at all, and I've CC'ed a couple of people as well)

Unfortunately, I have not had success with patch below on my system. :-(

Cheers,
Don
