Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1EOUS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 16:18:26 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34569 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1EOUSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 16:18:25 -0400
Date: Sun, 15 May 2011 16:18:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any value in centralizing a defn of "RUN_AT()"?
Message-ID: <alpine.DEB.2.00.1105151616530.28104@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
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


  i notice that a number of drivers duplicate a macro definition of
RUN_AT():

drivers/staging/vt6655/device.h:#define RUN_AT(x) (jiffies+(x))
drivers/net/irda/au1k_ir.c:#define RUN_AT(x) (jiffies + (x))
drivers/net/hamachi.c:#define RUN_AT(x) (jiffies + (x))
drivers/net/tulip/tulip.h:#define RUN_AT(x) (jiffies + (x))
drivers/net/wireless/airo.c:#define RUN_AT(x) (jiffies+(x))
drivers/net/rrunner.c:#define RUN_AT(x) (jiffies + (x))
drivers/net/bnx2.c:#define RUN_AT(x) (jiffies + (x))
drivers/net/3c59x.c:#define RUN_AT(x) (jiffies + (x))
drivers/net/fealnx.c:#define RUN_AT(x) (jiffies + (x))

  etc, etc.  any value in just defining that once in jiffies.h and
letting everyone use that?

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
