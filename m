Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2HAOLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:11:51 -0400
Received: from mout.web.de ([212.227.15.3]:50067 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab2HAOLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:11:49 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2012 10:11:49 EDT
From: "reiner.funck" <reiner.funck@web.de>
To: linux-kernel@vger.kernel.org
Subject: no SMP
Date: Wed, 01 Aug 2012 13:59:09 +0200
Message-ID: <1955983.zBURmPy5y8@linux-joum>
User-Agent: KMail/4.7.2 (Linux/3.1.0-1.2-desktop; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S916UPu6RTkt5txB40ruO1L12Lx6Ysq5X2T+R+jNC37
 yYi7JbNmM/eojCzJwnY/JC20Dsgtl7Csz+xKz47uqVgRZ+8+yq
 1Zzpc4KmmsRTbIeC8oMKu3WYuwdZCzGqSIdKhy1pC/s3EZcfYL
 10iYnkag1m/HO2RG88pNuIXORm7Pz4yxmlIlQ9ECe3KBELCApq
 dvs+YNE0rQ11fVgsCLCjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sirs,

I ask you for an advice. I get with all kernels (2.6, 3.1, ... 3.4) with all
distributions (suse, ubuntu, ...) in the system messages
....
                                                  CPU: Physical Processor ID:0
Jul 17 11:52:47 linux-joum kernel: [    0.009100] CPU: Processor Core ID: 0
Jul 17 11:52:47 linux-joum kernel: [    0.009101] mce: CPU supports 7 MCE 
banks
Jul 17 11:52:47 linux-joum kernel: [    0.009131] SMP alternatives 
switchingto UP code
Jul 17 11:52:47 linux-joum kernel: [    0.012309] Freeing SMP alternatives: 
20k freed
Jul 17 11:52:47 linux-joum kernel: [    0.012347] weird, boot CPU (#16) not 
listed by the BIOS.
Jul 17 11:52:47 linux-joum kernel: [    0.012348] SMP motherboard not 
detected.
Jul 17 11:52:47 linux-joum kernel: [    0.113986] SMP disabled
Jul 17 11:52:47 linux-joum kernel: [    0.113987] Performance Events: AMD 
Family 15h PMU driver.
Jul 17 11:52:47 linux-joum kernel: [    0.113989] ... version:                
0
Jul 17 11:52:47 linux-joum kernel: [    0.113989] ..
.....
I work with Asus Mainboard M5A99X EVO and AMD FX(tm) 8150 (eight core) 
processor. The Bios
Version is the newest (1208, used with default options). The Results are equal 
with Kernel
option acpi=off or on, maxcpus=8 or not..
Systemmonitoring shows one CPU.
Bios must have the missing information? (weird, boot CPU (#16) not listed by 
the BIOS).
Asus replied to my question: we test no Linux systems (windows7 works with 8 
cores).
Do you have an advice for me?

Yours faithfully
Reiner Funck
