Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1HYWwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:52:15 -0400
Received: from gherkin.frus.com ([192.158.254.49]:34700 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1HYWwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:52:14 -0400
X-Greylist: delayed 2495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 18:52:14 EDT
Date: Thu, 25 Aug 2011 17:10:37 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mtrr failure, 3.1-rc1
Message-ID: <20110825221037.GA6876@gherkin.frus.com>
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 09:03:35AM +0200, Anders Eriksson wrote:
> (mtrr issues)

Similar MTRR issue here with a K6-III/450, which I noticed when the X11
server was no longer able to allocate/configure a MTRR.  "cat /proc/mtrr"
shows nothing configured regardless of whether the X11 server is running.
I only see a diagnostic message to the effect of the MTRR not existing
when X11 exits.

Possibly significant: prior 3.X kernel versions would cause the X11
server to exit with a corrupted display after about 3-5 invocations.
Machine was otherwise usable, but had to reboot remotely to recover the
console display.  The "no MTRR" issue in 3.1-rc1 has thus far meant no
display corruption on X11 server exit: have run "startx" at least 10
times since booting 3.1-rc1.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "Every normal man must be tempted at times to spit
rct@frus.com       |   upon his hands, hoist the black flag, and begin
                   |   slitting throats."	-- H.L. Mencken
------------------------------------------------------------------------
