Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0DSGrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 02:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab0DSGrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 02:47:33 -0400
Date: Mon, 19 Apr 2010 08:47:17 +0200
From: Jerome Glisse <jglisse@redhat.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: Atombios Execution timeout
Message-ID: <20100419064717.GA2895@barney.localdomain>
References: <alpine.DEB.2.00.1004172146310.2797@parag-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004172146310.2797@parag-laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 10:04:56PM -0400, Parag Warudkar wrote:
> Hi Jerome,
> 
> On my laptop with a HD3650 GPU, during resume from RAM I get the 
> below errors -
> 
> [   80.484213] [drm:atom_op_jump] *ERROR* atombios stuck in loop for more 
> than 1sec aborting
> [   80.484218] [drm:atom_execute_table_locked] *ERROR* atombios stuck 
> executing FA30 (len 493, WS 0, PS 4) @ 0xFA71
> [   81.497547] [drm:atom_op_jump] *ERROR* atombios stuck in loop for more 
> than 1sec aborting
> [   81.497552] [drm:atom_execute_table_locked] *ERROR* atombios stuck 
> executing FA30 (len 493, WS 0, PS 4) @ 0xFA71
> [   81.548053] PM: resume of devices complete after 2129.312 msecs
> [   81.746649] PM: Finishing wakeup.
> [   81.746651] Restarting tasks ... done.
> 
> Since this happens only during resume may be the current 1 second time is 
> not sufficient for the resume case? I bumped it to 2 sec and it stopped 
> complaining. 
> 
> May be we should increase the timeout for only the resume case?
> 
> Thanks,
> 
> Parag

Please open bug and attach your video bios. See bottom of :
http://dri.freedesktop.org/wiki/TestingAndDebugging

I have a patch to bump it to 2sec but i still find strange that
it takes so long, i think it can be related to lockup.

Cheers,
Jerome
