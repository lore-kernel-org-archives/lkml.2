Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1KYUdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:33:54 -0500
Received: from gherkin.frus.com ([192.158.254.49]:39246 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab1KYUdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:33:53 -0500
Date: Fri, 25 Nov 2011 14:33:51 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie
Subject: [BUG] 3.2-rcX radeon KMS system freeze
Message-ID: <20111125203351.GA3651@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to get KDE4 running on an Alpha, and I have things to
the point where FreeNX (non-KMS) KDE4 sessions work just fine.  When I
try a KDE4 session on the console with 3.2-rc[1-2] kernels and KMS
enabled, the KDE4 splash screen appears, and the expected left-to-right
fade-in of the five startup progress icons happens.  As soon as the
fifth icon (the big "K") is done appearing, I assume plasma-desktop
starts, and that's where the system locks-up solid.  Can't switch
virtual consoles, can't login remotely, etc.: system doesn't even
respond to pings.  Have to hit the reset switch to recover.

After rebooting, there's nothing to be found in any of the X11 and/or
syslog files as far as "Oops" messages or other errors.

Similar bad things happen when I try to test Gnome-3 sessions (KMS
required for non-fallback mode).  With FreeNX, the best I can do is test
Gnome-3 fallback mode (Gnome-2).

Apologies for the less-than-useful bug report.  If there's anything I
can do to generate/capture more diagnostic info, please don't hesitate
to let me know.  I'll be able to try a 3.2-rc3 kernel later today.

--Bob
