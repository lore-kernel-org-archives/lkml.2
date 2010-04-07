Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab0DGV7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:59:39 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41482 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab0DGV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NR7/uEkh2Bi/RUj5dS0GYUrx4UXjr4NGfmxUuZXr5YYqj/eTDwi37efF68rvGt8dQG
         1/wTlP1YAOqJXViLPqOR2Od+Gg4DTvCTIXiiiq+wBI3hAtXkshSHKcCH++qxGapBY2II
         X5JaYoyIFrD/cOcdmyNOJg3RlCbg4KHMfVkfQ=
Date: Wed, 7 Apr 2010 23:59:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15624] [BUG] percpu misaligned allocation
Message-ID: <20100407215926.GA10002@nowhere>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.mnH.stPvLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JVS2s9dmTsP.A.mnH.stPvLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 11:13:49PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15624
> Subject		: [BUG] percpu misaligned allocation
> Submitter	: Frederic Weisbecker <fweisbec@gmail.com>
> Date		: 2010-03-18 4:49 (21 days old)
> Message-ID	: <20100318044930.GC5045@nowhere>
> References	: http://marc.info/?l=linux-kernel&m=126888780031992&w=2


This has been fixed with "eb1e79611cc9bfe21978230e3521e77ea2d7874a"
(perf: Correctly align perf event tracing buffer).

The ticket can be closed, thanks!

