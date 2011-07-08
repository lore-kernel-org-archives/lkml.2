Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1GHTgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1GHTgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:36:38 -0400
Message-ID: <4E175C45.1060700@redhat.com>
Date: Fri, 08 Jul 2011 15:36:37 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.0.0-rc6 ~9X system time degradation on kernbench
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some numbers out of kernbench.  System Time & Context Switches
climb dramatically between 2.6.38 and 3.0.0-rc6.  Currently bisecting to
find out why.  .config is based on Fedora's x86_64 .config.

Thu Jul  7 18:23:48 EDT 2011
2.6.38.8-32.fc15.x86_64
Average Half load -j 64 Run (std deviation):
Elapsed Time 155.376 (3.77835)
User Time 4536.18 (11.5886)
System Time 1810.42 (27.0879)
Percent CPU 4086 (100.252)
Context Switches 794941 (3757.3)
Sleeps 754029 (10516)

Thu Jul  7 19:50:38 EDT 2011
3.0.0-rc6
Average Half load -j 64 Run (std deviation):
Elapsed Time 466.362 (2.78605)
User Time 8616.43 (22.5528)
System Time 14583.6 (63.2273)
Percent CPU 4974.2 (19.6265)
Context Switches 2.69157e+06 (7679.26)
Sleeps 827950 (3050.16)

Thu Jul  7 21:30:22 EDT 2011
2.6.39
Average Half load -j 64 Run (std deviation):
Elapsed Time 250.044 (2.55373)
User Time 5361.27 (14.6996)
System Time 5173.44 (14.9366)
Percent CPU 4212.8 (40.4314)
Context Switches 1.28385e+06 (1610.42)
Sleeps 741129 (3339.19)

Fri Jul  8 12:21:29 EDT 2011
3.0.0-rc1
Average Optimal load -j 64 Run (std deviation):
Elapsed Time 435.338 (5.45314)
User Time 6125.78 (15.2816)
System Time 8346.45 (62.5065)
Percent CPU 3324.2 (29.0637)
Context Switches 6.42863e+06 (23420)
Sleeps 996764 (3744.98)

P.
