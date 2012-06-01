Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab2FAItD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:49:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40585 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759102Ab2FAIs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:48:58 -0400
Date: Fri, 1 Jun 2012 10:48:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120601084854.GA3969@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bojan Smojver <bojan@rexursive.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
 <201205211518.39137.rjw@sisk.pl>
 <882dce83-b79e-4470-af25-edb8429fb7e5@email.android.com>
 <201205212353.42639.rjw@sisk.pl>
 <1337637359.1647.67.camel@shrek.rexursive.com>
 <20120524145122.GA26743@x1.osrc.amd.com>
 <07f1a575-ec44-40b7-bd36-576f883f188d@email.android.com>
 <20120531162342.GA3541@x1.osrc.amd.com>
 <91027f5c-239f-4b91-b6b4-2fcac6e1bcb7@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <91027f5c-239f-4b91-b6b4-2fcac6e1bcb7@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 12:03:47PM +1000, Bojan Smojver wrote:
> >Ok, I finally gave the above a run, here's the dmesg after a successful
> >suspend-resume cycle. It looks ok except the funny characters after
> >
> >"[  380.938864] PM: Compressing and saving image data (75689 pages)
> >..."
> >
> >I'll keep running it the next couple of days/weeks and report any
> >instabilities.

> Thanks for testing. The funny characters are backspaces printed by the
> progress indicator. :-)

I know, this output should probably be turned off if we're both
suspending to disk and ram so as not to pollute dmesg. Normal,
suspend-to-disk cycle doesn't put that output in dmesg.

-- 
Regards/Gruss,
    Boris.
