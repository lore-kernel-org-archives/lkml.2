Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0EJAdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 20:33:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:54398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0EJAdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 20:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,358,1270450800"; 
   d="scan'208";a="516421984"
Subject: Re: linux-next: Tree for May 7 (apei)
From: Huang Ying <ying.huang@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20100507085509.fb5682d4.randy.dunlap@oracle.com>
References: <20100507155520.75026a8b.sfr@canb.auug.org.au>
	 <20100507085509.fb5682d4.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 08:33:10 +0800
Message-ID: <1273451590.3344.52.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 23:55 +0800, Randy Dunlap wrote:
> On Fri, 7 May 2010 15:55:20 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100506:
> 
> 
> drivers/acpi/apei/einj.c:127:error: implicit declaration of function 'ndelay'
> => needs to #include <linux/delay.h>
> 
> 
> 
> ghes.c:(.text+0x119e71): undefined reference to `apei_mce_report_mem_error'
> 
> CONFIG_X86_MCE is not enabled, so make never descends into the
> arch/x86/kernel/cpu/mcheck/ sub-directory to build mce-apei.o.
> 
> config attached.

Hi, Randy,

Thank you for your reporting. I will fix it as soon as possible.

Hi, Len,

Fixing them in a new fixing patch or providing a update version (v2) of
whole patch queue, which one do you prefer?

Best Regards,
Huang Ying


