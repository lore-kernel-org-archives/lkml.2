Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1ERVUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:20:04 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34640 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab1ERVUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:20:02 -0400
Date: Wed, 18 May 2011 16:19:53 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: David <david@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel fails to build multi-threaded on ecryptfs home
Message-ID: <20110518211952.GC21127@boyd.l.tihix.com>
References: <4DD41613.4040102@unsolicited.net>
 <4DD41CA6.8060808@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD41CA6.8060808@unsolicited.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 18, 2011 at 08:23:18PM +0100, David <david@unsolicited.net> wrote:
> On 18/05/11 19:55, David wrote:
> > I'm seeing some unpleasant things when building multithreaded when running the latest kernels. The compiler complains of truncated files and implausible characters. Single threaded builds seem fine.
> 
> My impromptu bisection currently shows
> 
>     2.6.38 OK
>     2.6.39rc2 Affected
> 
> so it looks like this problem first appears early in the .39 series.

Thanks for the bisection David. I'm looking into this now.

Tyler

> 
> Cheers
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
