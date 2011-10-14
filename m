Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab1JNQ6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:58:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57940 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab1JNQ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:58:46 -0400
Message-ID: <1318611542.2223.47.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
Cc: "Seger, Mark" <mark.seger@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 18:59:02 +0200
In-Reply-To: <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
	 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
	 <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 octobre 2011 à 17:52 +0100, Oberman, Laurence (HAS GSE) a
écrit :
> Standard RHEL kernel build.
> What the customer would be using.
> 
> [root@linuxbeast boot]# cat config-2.6.32-131.6.1.el6.x86_64 | grep NR
> CONFIG_NR_CPUS=4096

Then something must be wrong.... what are your nr_cpu_ids /
nr_cpumask_bits values ?


dmesg | grep nr_cpu_ids



