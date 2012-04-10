Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2DJQ6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:58:42 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60057 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2DJQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:58:41 -0400
X-Greylist: delayed 4793 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2012 12:58:41 EDT
Date: Tue, 10 Apr 2012 11:38:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: shouldn't OMAP4 keyboard depend on ARCH_OMAP4?
Message-ID: <alpine.DEB.2.02.1204101137280.12150@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  i asked about this on linux-omap list but didn't see a reply.
here's a snippet from drivers/input/keyboard/Kconfig:

config KEYBOARD_OMAP
        tristate "TI OMAP keypad support"
        depends on (ARCH_OMAP1 || ARCH_OMAP2)
        help
          Say Y here if you want to use the OMAP keypad.

          To compile this driver as a module, choose M here: the
          module will be called omap-keypad.

config KEYBOARD_OMAP4
        tristate "TI OMAP4 keypad support"
        help
          Say Y here if you want to use the OMAP4 keypad.

          To compile this driver as a module, choose M here: the
          module will be called omap4-keypad.

  pretty sure that second snippet should depend on ARCH_OMAP4, no?

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
