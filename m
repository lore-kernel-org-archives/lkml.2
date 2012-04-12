Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331Ab2DLOvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:51:40 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:33246 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991Ab2DLOvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:51:39 -0400
Date: Thu, 12 Apr 2012 10:51:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel cleanup scripts and wiki page now updated
Message-ID: <alpine.DEB.2.02.1204121048300.18349@oneiric>
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


  i tidied up the wiki page for the kernel cleanup scripts and updated
the examples:

http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup_scripts

and all of the scripts listed there find something.

  as one example -- the script that looks for bad "select" directives
in Kconfig files -- we have:

===== LEDS_TRIGGER
arch/arm/mach-s3c24xx/Kconfig:404:	select LEDS_TRIGGER

  a quick grep suggests that should be "LEDS_TRIGGERS", so that's the
sort of thing that is being identified.  enjoy.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
