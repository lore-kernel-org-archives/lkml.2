Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0IWJvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:51:32 -0400
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:40667 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432Ab0IWJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:51:30 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19611.8986.142128.168878@elektron.ikp.physik.tu-darmstadt.de>
Date: Thu, 23 Sep 2010 11:51:22 +0200
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
In-Reply-To: <4C9A1FB7.9050902@oracle.com>
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
	<20100921151033.80e61747.randy.dunlap@oracle.com>
	<19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
	<4C9A1FB7.9050902@oracle.com>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v0.99a by 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.9.23.94216
X-PMX-RELAY: mailout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Randy" == Randy Dunlap <randy.dunlap@oracle.com> writes:

    Randy> On 09/22/10 02:44, Uwe Bonnes wrote:
    >> >> is there any SYSRQ key that forces the video system to console
    >> mode, >> especially when using KMS and allows to work on.
    >> 
    Randy> sysrq-v help message says:
    >>
    Randy> force-fb(V) = "Restore framebuffer console"
    >>  How is that documented outside the sysrq itself?
    >> 
    >> /usr/src/linux-2.6.36-rc4-19/Documentation/sysrq.txt:
    >> 
    >> 'v' - Dumps Voyager SMP processor info to your console

    Randy> Yes, I noticed that and I posted a patch for it yesterday.

Thanks for caring!

However 2.6.36-rc4 also fixed my hibernate problem:

commit 84e1d836ef0759a152578a961894824bde89596f
Merge: 20f4cad 6715045
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Sep 11 15:50:53 2010 -0700

    Merge branch 'pm-fixes' of
    git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
    
    * 'pm-fixes' of
      ...
      PM / Hibernate: Avoid hitting OOM during preallocation of memory
      ...

so I no longer hit the problem with the dark screen...

Bye
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
