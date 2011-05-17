Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1EQOjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:39:01 -0400
Received: from services116.cs.uwaterloo.ca ([129.97.152.169]:40850 "EHLO
	services116.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755161Ab1EQOjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:39:00 -0400
Message-ID: <4DD28873.8050706@uwaterloo.ca>
Date: Tue, 17 May 2011 10:38:43 -0400
From: Sarah Nadi <snadi@uwaterloo.ca>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: jkosina@suse.cz
CC: starvik@axis.com, linux-kernel@vger.kernel.org
Subject: [Patch 1/1]: cris: typo in mach-fs Makefile
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Miltered: at mailchk-m03 with ID 4DD2887B.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 23b5b068-a219-4b56-9133-3855fc7927a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Nadi<snadi@uwaterloo.ca>

There is a possible typo in arch/cris/arch-v32/mach-fs/Makefile. Check diff below


--- linux-2.6.38/arch/cris/arch-v32/mach-fs/Makefile.orig    2011-03-14 
21:20:32.000000000 -0400
+++ linux-2.6.38/arch/cris/arch-v32/mach-fs/Makefile    2011-05-16 
11:24:21.627239213 -0400
@@ -4,7 +4,7 @@
  #

  obj-y   := dma.o pinmux.o io.o arbiter.o
-bj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o
+obj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o
  obj-$(CONFIG_CPU_FREQ)   += cpufreq.o

  clean:



Signed-off-by: Sarah Nadi <snadi@uwaterloo.ca>
