Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2FAJDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:03:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35264 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab2FAJDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:03:41 -0400
Date: Fri, 1 Jun 2012 11:03:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120601090338.GB3969@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bojan Smojver <bojan@rexursive.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <201205211518.39137.rjw@sisk.pl>
 <882dce83-b79e-4470-af25-edb8429fb7e5@email.android.com>
 <201205212353.42639.rjw@sisk.pl>
 <1337637359.1647.67.camel@shrek.rexursive.com>
 <20120524145122.GA26743@x1.osrc.amd.com>
 <07f1a575-ec44-40b7-bd36-576f883f188d@email.android.com>
 <20120531162342.GA3541@x1.osrc.amd.com>
 <91027f5c-239f-4b91-b6b4-2fcac6e1bcb7@email.android.com>
 <20120601084854.GA3969@liondog.tnic>
 <1338541040.1634.5.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1338541040.1634.5.camel@shrek.rexursive.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 06:57:20PM +1000, Bojan Smojver wrote:
> On Fri, 2012-06-01 at 10:48 +0200, Borislav Petkov wrote:
> > Normal, suspend-to-disk cycle doesn't put that output in dmesg.
> 
> It does, but that kernel state never gets used again in that case. The
> state before the image writing starts is the one used on thaw, so these
> messages never appear anywhere.

Ok, thanks for clarifying, I always wondered how that worked but was too
lazy to look :-).

> But yeah, I do not see why these should ever go to any dmesg output.
> They should just go to the screen.

Yep.

-- 
Regards/Gruss,
    Boris.
