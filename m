Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0ICSGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:06:18 -0400
Received: from tobey.rudd-o.com ([117.121.243.202]:44011 "EHLO
	tobey.rudd-o.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab0ICSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:06:17 -0400
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2010 14:06:17 EDT
References: <4C800B06.90005@genband.com>
Message-Id: <5BC8670C-E7B0-4827-BB74-B96AF327CF1D@rudd-o.com>
From: "Manuel Amador (Rudd-O)" <rudd-o@rudd-o.com>
To: Chris Friesen <chris.friesen@genband.com>
In-Reply-To: <4C800B06.90005@genband.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [fuse-devel] ionice and FUSE-based filesystems?
Date: Fri, 3 Sep 2010 10:38:20 -0700
Cc: "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also wanna know this!!

         Manuel Amador (Rudd-O)
         Cloud.com, Inc. -- http://www.cloud.com

On Sep 2, 2010, at 13:37, Chris Friesen <chris.friesen@genband.com>  
wrote:

>
> I'm curious about the limits of using ionice with multiple layers of
> filesystems and devices.
>
> In particular, we have a scenario with a FUSE-based filesystem running
> on top of xfs on top of LVM, on top of software RAID, on top of  
> spinning
> disks.  (Something like that, anyways.)  The IO scheduler is CFQ.
>
> In the above scenario would you expect the IO nice value of the writes
> done by a task to be propagated all the way down to the disk  
> writes?  Or
> would they get stripped off at some point?
>
> Thanks,
> Chris
>
> -- 
> Chris Friesen
> Software Developer
> GENBAND
> chris.friesen@genband.com
> www.genband.com
>
> --- 
> --- 
> --- 
> ---------------------------------------------------------------------
> This SF.net Dev2Dev email is sponsored by:
>
> Show off your parallel programming skills.
> Enter the Intel(R) Threading Challenge 2010.
> http://p.sf.net/sfu/intel-thread-sfd
> _______________________________________________
> fuse-devel mailing list
> fuse-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/fuse-devel
