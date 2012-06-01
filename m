Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab2FAI5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:57:24 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:49020 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642Ab2FAI5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:57:23 -0400
Message-ID: <1338541040.1634.5.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 01 Jun 2012 18:57:20 +1000
In-Reply-To: <20120601084854.GA3969@liondog.tnic>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
	 <201205211518.39137.rjw@sisk.pl>
	 <882dce83-b79e-4470-af25-edb8429fb7e5@email.android.com>
	 <201205212353.42639.rjw@sisk.pl>
	 <1337637359.1647.67.camel@shrek.rexursive.com>
	 <20120524145122.GA26743@x1.osrc.amd.com>
	 <07f1a575-ec44-40b7-bd36-576f883f188d@email.android.com>
	 <20120531162342.GA3541@x1.osrc.amd.com>
	 <91027f5c-239f-4b91-b6b4-2fcac6e1bcb7@email.android.com>
	 <20120601084854.GA3969@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 10:48 +0200, Borislav Petkov wrote:
> Normal, suspend-to-disk cycle doesn't put that output in dmesg.

It does, but that kernel state never gets used again in that case. The
state before the image writing starts is the one used on thaw, so these
messages never appear anywhere.

But yeah, I do not see why these should ever go to any dmesg output.
They should just go to the screen.

-- 
Bojan

