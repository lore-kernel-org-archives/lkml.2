Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab1CCXAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:00:25 -0500
Received: from mail.candelatech.com ([208.74.158.172]:56346 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab1CCXAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:00:24 -0500
Message-ID: <4D701D88.2030709@candelatech.com>
Date: Thu, 03 Mar 2011 15:00:24 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Compile failure 'Bad ELF' ??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just merged in wireless-testing 2.6.38-rc7 and I'm getting
a strange build error.  This tree has a bunch of my own hacks
in it too...

[greearb@build-32 wireless-testing-ct.p4s]$ make bzImage
make -C /home/greearb/git/linux.wireless-testing-ct O=/home/greearb/kernel/2.6/wireless-testing-ct.p4s/. bzImage
   GEN     /home/greearb/kernel/2.6/wireless-testing-ct.p4s/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
   Using /home/greearb/git/linux.wireless-testing-ct as source for kernel
   GEN     /home/greearb/kernel/2.6/wireless-testing-ct.p4s/Makefile
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    /home/greearb/git/linux.wireless-testing-ct/scripts/checksyscalls.sh
   MKELF   scripts/mod/elfconfig.h
Error: not ELF
make[4]: *** [scripts/mod/elfconfig.h] Error 1
make[3]: *** [scripts/mod] Error 2
make[2]: *** [scripts] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2


It appears to have something to do with how things are configured,
as I was able to build a more stripped-down version for the C3 kernel
from the same source tree.

Any ideas on what sort of thing can cause this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

