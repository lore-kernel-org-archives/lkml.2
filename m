Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0IWNBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:01:49 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:45795 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab0IWNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:01:47 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19611.20403.865248.695829@elektron.ikp.physik.tu-darmstadt.de>
Date: Thu, 23 Sep 2010 15:01:39 +0200
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
In-Reply-To: <19611.8986.142128.168878@elektron.ikp.physik.tu-darmstadt.de>
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
	<20100921151033.80e61747.randy.dunlap@oracle.com>
	<19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
	<4C9A1FB7.9050902@oracle.com>
	<19611.8986.142128.168878@elektron.ikp.physik.tu-darmstadt.de>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v0.99a by 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.9.23.124818
X-PMX-RELAY: mailout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Uwe" == Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de> writes:

>>>>> "Randy" == Randy Dunlap <randy.dunlap@oracle.com> writes:
...
    Uwe> However 2.6.36-rc4 also fixed my hibernate problem:

    Uwe> commit 84e1d836ef0759a152578a961894824bde89596f Merge: 20f4cad
    Uwe> 6715045 Author: Linus Torvalds <torvalds@linux-foundation.org>
    Uwe> Date: Sat Sep 11 15:50:53 2010 -0700

    Uwe>     Merge branch 'pm-fixes' of
    Uwe> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
    
    Uwe>     * 'pm-fixes' of ...  PM / Hibernate: Avoid hitting OOM during
    Uwe> preallocation of memory ...

    Uwe> so I no longer hit the problem with the dark screen...

I burried the problem too early. 

On another hibernate attempt on 2.6.36-rc4, now the image again was not
written to disk, the screen turn black and no ALT-CTL-SYSRQ combination
helped. Especially I tried  ALT-CTL-SYSRQ ad 'v','V', ALT-CTL 'v' and
ALT-CTL 'V'...
 
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
