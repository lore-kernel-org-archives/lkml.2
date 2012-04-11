Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab2DKUBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab2DKUB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:01:28 -0400
Date: Wed, 11 Apr 2012 16:01:05 -0400
From: Dave Jones <davej@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>, David Miller <davem@davemloft.net>,
        preining@logic.at, egrumbach@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        ilw@linux.intel.com
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120411200105.GA22002@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, preining@logic.at,
	egrumbach@gmail.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	ilw@linux.intel.com
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
 <20120410.225451.92022308007980352.davem@davemloft.net>
 <20120411184047.GJ12044@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411184047.GJ12044@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 02:40:47PM -0400, Ted Ts'o wrote:

 > I'll note that I've been having troubles with my iwlagn driver losing
 > the ability to connect to WPA2 authenticated AP's at work (Google
 > Cambridge).  This has been true for since sometime around 3.0; my
 > excuse for why I haven't tried bisecting it is that it can take
 > several hours for the bug to manifest itself, and when it does, it's
 > much simpler to either (a) reboot, or (b) rmmod iwlagn and then
 > modprobe iwlagn.
 > 
 > I also don't know if it's a problem with (a) the iwlagn driver, (b) my
 > hardware, (c) the network-manager WPA code, or (d) the enterprise AP
 > that we are using, or some combination of the four.  On my todo list
 > is to get a completely different 802.11abn wireless PC Card, and then
 > try to see if the problem reproduces itself there, and then see if I
 > can at some point try to set aside a full week where I'd do nothing
 > else with my laptop but git bisects full-time.
 > 
 > Sometimes, git bisects are not terribly useful ways of trying to find
 > the problem commits --- and I've tried doing them before to debug
 > iwlagn problems twice before, and past experience tells me it's a
 > minimum of 1, and usually more like 2 or 3 days of lost productivity
 > while I try to debug it --- and that's when the problem is obvious
 > within 10 or 20 minutes of the reboot.  :-(

iwlwifi has a debug module option which generates a ton of spew, but
the Intel developers have managed to diagnose several iwlwifi problems
I've had by staring at the dumps. Starting there is probably going to
be faster than bisecting. (Especially when you're in a situation like I was
where it was just 'differently broken' at various points in time).

	Dave
