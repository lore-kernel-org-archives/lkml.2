Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2DPP1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:27:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61777 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2DPP1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:27:38 -0400
Date: Mon, 16 Apr 2012 11:27:16 -0400
From: "John L. Males" <jlmales@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What Information is Required for Bug or Very Intermitent Suspend
 Bug
Message-Id: <20120416112716.916e33fa.jlmales@gmail.com>
Reply-To: jlmales@gmail.com
Organization: Toronto, Ontario
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Gentlemen,

Please CC me on replies as I do not subscribe to the Linux
Kernel Mailing List.

It has been a long time since I communicated on this mailing
list.

I was using the 3.2.14 stock kernel yesterday I built
 a few days earlier.  When I did a routine suspend the laptop,
NC6400, blanked the screen in a bit longer time than I am used
to, and left the power LEDs on, not the blinking LEDs I am
used to having when the laptop is in suspend.  I allowed 2+
minutes for the laptop to reach suspend state, but after 2+
minutes the power LEDs were still on solid.  I tried to press
the power button quickly in hopes it might wake up the laptop
and did not.  The screen off power LEDs on solid persisted.  I
tried pressing the power button a few more times for 1/2 a
second or so.  Still the screen stayed blank and the power
LEDs remained solid.  I then pressed the power button for
longer than 4 seconds and as expected the laptop powered down.

I had been using the 3.2.13 stock Linux kernel I built shortly
after its release for over a week using suspend frequently
with no problem for times during day and for overnight with no
problems.  I have since reverted back to the 3.2.13 Kernel for
now as I know it has worked for me well, aside from some one
other odd issue related to file systems that may or may not be
3.2.14 related. I have reviewed the change log for the 3.2.15
kernel, but do not find anything in the change log that might be
directly or indirectly related to this suspend problem.

What information specific to the suspend issue I encountered
would I need to collect now or for the next time this issue
occurs?  I only had this problem once before, but with a
non-stock kernel that was also much older that only happened
once so I decided not to report to the distribution and
distribution patches that would likely cloud the kernel.  I am
now using a stock kernel with no additional patches or like to
the kernel which I would hope would enable what appears may be
a 3.2.14 or a very intermittent kernel bug.


Regards,

John L. Males
Toronto, Ontario
Canada
16 April 2012 11:27


==============================================================
2012-04-16 11:05:30.711250730-0400-EDT

16 Apr 11:05:30 ntpdate[13432]: ntpdate 4.2.6p2@1.2194-o Sun
Oct 17 13:35:14 UTC 2010 (1)

16 Apr 11:06:04 ntpdate[13437]: step time server 24.215.0.24
offset 0.001294 sec

Linux 3.2.13-kernel.org-jlm-001-amd64 #1 SMP PREEMPT Sat Mar 24
23:06:18 EDT 2012

Modified Debian GNU/Linux 6.0.3 (squeeze)
Planning, Upgrade, Modifications from Highly modified
Debian 4.x Etch

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk+MOlQACgkQ+V/XUtB6aBCKDQCfUDbvQekNO3Bn2V+J56VPP10L
T6sAoIgb0Ltm5nM0LA+7tac7Jj/nrtLW
=wN1g
-----END PGP SIGNATURE-----
