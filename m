Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0DVNwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:52:41 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:47912
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789Ab0DVNwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:52:39 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 09:52:39 EDT
Date: Thu, 22 Apr 2010 15:45:50 +0200
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-raid <linux-raid@vger.kernel.org>
Subject: Compile error with 2.6.34-rc5+
Message-ID: <20100422134550.GA4886@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While compiling current git HEAD on one of my boxes I got a compile error.
Current head is at 1ef6ce7a340f9ed139a73147ff9cf7ad56889414 and the
compile error is

drivers/built-in.o: In function `raid5_compute_sector':
raid5.c:(.text+0x85a36): undefined reference to `__umoddi3'
raid5.c:(.text+0x85a67): undefined reference to `__umoddi3'
raid5.c:(.text+0x85a9c): undefined reference to `__umoddi3'
raid5.c:(.text+0x85acd): undefined reference to `__umoddi3'
raid5.c:(.text+0x85b23): undefined reference to `__umoddi3'
drivers/built-in.o:raid5.c:(.text+0x85b54): more undefined references to
`__umoddi3' follow

The config file was taken straight from a -rc4 kernel and make oldconfig
was run before that. 
This runs on/is compiled for a 32bit Pentium IV system so I wonder why umoddi3 is being used.

Kind regards,
Michael
