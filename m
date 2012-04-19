Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2DSQte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:49:34 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:45621 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2DSQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:49:33 -0400
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 12:49:33 EDT
Date: Thu, 19 Apr 2012 18:38:00 +0200
From: Nico Schottelius <nico-linux-20120419@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20120419@schottelius.org>
Subject: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120419163800.GB13977@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.3.2-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've dived through some forums and news articles, grep'ed through
the kernel source tree, but not found a good reference to the current
state of Thunderbolt support under Linux.

I'm thinking of connecting a 27" Apple Display to my Mac Book Air 13",
but some quick testing showed that Xorg does not detect the display
(no xrandr output).

Anyone working on this / has an experiemental branch to test /
sourcecode available?

Cheers,

Nico

P.S.: Linux is pretty stable on the MBA 4,2 nowadays!
      (though Xorg isn't - it crashes from time to time...)


-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
