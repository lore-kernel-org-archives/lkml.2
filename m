Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab2DKSky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:40:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43779 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab2DKSkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:40:53 -0400
Date: Wed, 11 Apr 2012 14:40:47 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Miller <davem@davemloft.net>
Cc: preining@logic.at, egrumbach@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        ilw@linux.intel.com
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120411184047.GJ12044@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, preining@logic.at,
	egrumbach@gmail.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	ilw@linux.intel.com
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
 <20120410.225451.92022308007980352.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410.225451.92022308007980352.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:54:51PM -0400, David Miller wrote:
> 
> In those 20 kernel revisions you, or a party interested in helping
> you, could have GIT bisected the guilty change which introduced
> the problem.
> 
> Then we'd have something concrete to go on, and use to work towards a
> fix.
> 
> Right now there isn't nearly enough information to fix the problem.

I'll note that I've been having troubles with my iwlagn driver losing
the ability to connect to WPA2 authenticated AP's at work (Google
Cambridge).  This has been true for since sometime around 3.0; my
excuse for why I haven't tried bisecting it is that it can take
several hours for the bug to manifest itself, and when it does, it's
much simpler to either (a) reboot, or (b) rmmod iwlagn and then
modprobe iwlagn.

I also don't know if it's a problem with (a) the iwlagn driver, (b) my
hardware, (c) the network-manager WPA code, or (d) the enterprise AP
that we are using, or some combination of the four.  On my todo list
is to get a completely different 802.11abn wireless PC Card, and then
try to see if the problem reproduces itself there, and then see if I
can at some point try to set aside a full week where I'd do nothing
else with my laptop but git bisects full-time.

Sometimes, git bisects are not terribly useful ways of trying to find
the problem commits --- and I've tried doing them before to debug
iwlagn problems twice before, and past experience tells me it's a
minimum of 1, and usually more like 2 or 3 days of lost productivity
while I try to debug it --- and that's when the problem is obvious
within 10 or 20 minutes of the reboot.  :-(

						- Ted
