Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2CATVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:21:16 -0500
Received: from ip94-39-241-190.ct.co.cr ([190.241.39.94]:41152 "EHLO
	bruno.wildbear.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2CATVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:21:14 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2012 14:21:14 EST
Date: Thu, 1 Mar 2012 13:12:54 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #42631] Sound broken in 3.2.0 and 3.2.1
In-Reply-To: <JM4ZOHxb-FL.A.E8G.ghsRPB@chimera>
Message-ID: <alpine.LNX.2.00.1203011255340.986@bruno>
References: <1qKPXd1RqtP.A.wjG.ShsRPB@chimera> <JM4ZOHxb-FL.A.E8G.ghsRPB@chimera>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 24 Feb 2012, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 3.1 and 3.2.
>
> The following bug entry is on the current list of known regressions
> introduced between 3.1 and 3.2.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42631
> Subject		: Sound broken in 3.2.0 and 3.2.1
> Submitter	: Joseph Parmelee <jparmele@wildbear.com>
> Date		: 2012-01-13 19:44 (42 days old)
> Message-ID	: <alpine.LNX.2.00.1201131241090.1239@bruno>
> References	: http://marc.info/?l=linux-kernel&m=132648462806235&w=2
>
>
>

I am informed by the hda sound developer that alsactl is expected to be run
during the system initialization.  I was not aware of this requirement
previously.  This is a regression only in the sense that it worked before
(in linux 3.1) without alsactl.  However, now inclusion of an "alsactl
store" in the shutdown script and "alsactl restore" in the startup script
seems to solve the problem without the need for a dummy run of aplay.

I do think that this requirement should be made more prominently in the
documentation, preferably in linux/Documentation/sound.


Best regards,

Joseph Parmelee
