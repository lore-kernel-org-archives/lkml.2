Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1CRUwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:52:35 -0400
Received: from jonshouse.co.uk ([91.84.151.33]:35182 "EHLO
	mail.jonshouse.co.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab1CRUwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:52:32 -0400
X-Greylist: delayed 2078 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 16:52:32 EDT
Subject: 2.6.38 Cant compile
From: Jonathan Andrews <jon@jonshouse.co.uk>
Reply-To: jon@jonshouse.co.uk
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 20:19:22 +0000
Message-ID: <1300479562.18471.7.camel@jonspc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Assp-noDelay: 10.10.10.6
X-Assp-ID: ASSP.nospam (79566-05852)
X-Assp-Version: 1.6.1.2(1.0.01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't get very far... 

Sorry for posting here but google shed no light on this

Any constructive comments welcome.

Cheers,
Jon

# make
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from /usr/src/linux-2.6.38/arch/x86/include/asm/bitops.h:449,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:17,
                 from /usr/src/linux-2.6.38/arch/x86/include/asm/percpu.h:44,
                 from /usr/src/linux-2.6.38/arch/x86/include/asm/current.h:5,
                 from /usr/src/linux-2.6.38/arch/x86/include/asm/processor.h:15,
                 from /usr/src/linux-2.6.38/arch/x86/include/asm/atomic.h:6,
                 from include/linux/crypto.h:20,
                 from arch/x86/kernel/asm-offsets_32.c:7,
                 from arch/x86/kernel/asm-offsets.c:2:
/usr/src/linux-2.6.38/arch/x86/include/asm/arch_hweight.h: In function `__arch_hweight32':
/usr/src/linux-2.6.38/arch/x86/include/asm/arch_hweight.h:29: parse error before string constant
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

# gcc --version
gcc (GCC) 3.2.2
Copyright (C) 2002 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.



