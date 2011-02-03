Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1BCLUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:20:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44596 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab1BCLUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g309qTaD/ZrBUthCK21x4ZSWDkvkODnst7Re/TxjPMjQdn9jK4eBBt6gzN1ghuQ/df
         Qa0oscfbsatrFIHVfP69NvffG5OoAh3GLeh/D5KhfQjJxrxih3NcgyutC1wgH3Hci1yK
         3dBi4XxAJMC5Gl1I6QAhr1ZxyE30yiNOK9Ym0=
Date: Thu, 3 Feb 2011 12:23:16 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.38-rc3-git1: Reported regressions 2.6.36 -> 2.6.37
Message-ID: <20110203112316.GA3718@linux-yscl.site>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu  3.Feb'11 at  1:03:41 +0100, Rafael J. Wysocki wrote:
> 
> If you know of any other unresolved post-2.6.36 regressions, please let us know
> either and we'll add them to the list.  Also, please let us know if any
> of the entries below are invalid.

I'm sorry if I'm overlooking something, but as far as I can see the regression
reported here:

https://lkml.org/lkml/2011/1/24/457

is not in the list (update on that report: reverting that commit on top of 
2.6.37 fixes the issue).

After some time, I also ended up finding an earlier report in the kernel bugzilla
which I think is the same regression (it was bisected to the same commit):

https://bugzilla.kernel.org/show_bug.cgi?id=24982

but I do not see it in the list either, even though it's marked as a
regression in the bugzilla.

The issue was also present in 2.6.38-rc2 last time I tested.
