Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1ACVQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:16:42 -0500
Received: from gherkin.frus.com ([192.158.254.49]:54054 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1ACVQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:16:39 -0500
X-Greylist: delayed 1172 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jan 2011 16:16:39 EST
Date: Mon, 3 Jan 2011 14:57:05 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.37-rc8 build failure on Alpha
Message-ID: <20110103205705.GA24522@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This probably happened before -rc8, but was not an issue for 2.6.36.

The 2.6.37-rc8 kernel build on alpha fails as follows:

(...)
  LD      usr/built-in.o
  AS      arch/alpha/kernel/entry.o
  CC      arch/alpha/kernel/traps.o
cc1: warnings being treated as errors
In file included from /usr/src/linux-2.6/arch/alpha/include/asm/mmu_context.h:22,
                 from arch/alpha/kernel/traps.c:26:
/usr/src/linux-2.6/arch/alpha/include/asm/io.h: In function '__set_hae':
/usr/src/linux-2.6/arch/alpha/include/asm/io.h:41: error: 'arch_local_irq_save' is static but used in inline function '__set_hae' which is not static
/usr/src/linux-2.6/arch/alpha/include/asm/io.h:49: error: 'arch_local_irq_restore' is static but used in inline function '__set_hae' which is not static
make[1]: *** [arch/alpha/kernel/traps.o] Error 1
make: *** [arch/alpha/kernel] Error 2

--Bob
rct_at_frus_dot_com
