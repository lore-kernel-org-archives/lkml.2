Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab0GWNp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:45:56 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:38859 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756169Ab0GWNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:45:55 -0400
Date: Fri, 23 Jul 2010 23:45:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Marius Tolzmann <tolzmann@molgen.mpg.de>
Subject: Re: [Bug #16348] kswapd continuously active when doing IO
Message-ID: <20100723134525.GC7362@dastard>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
 <PRbv8sgxY6G.A.NWF.-UYSMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PRbv8sgxY6G.A.NWF.-UYSMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 02:15:54PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16348
> Subject		: kswapd continuously active when doing IO
> Submitter	: Marius Tolzmann <tolzmann@molgen.mpg.de>
> Date		: 2010-07-07 10:58 (17 days old)

The fix for this is already in 2.6.36-rc6.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
