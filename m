Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0IWQbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:31:36 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:48701 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754406Ab0IWQbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:31:35 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19611.32996.817920.499437@elektron.ikp.physik.tu-darmstadt.de>
Date: Thu, 23 Sep 2010 18:31:32 +0200
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
In-Reply-To: <20100923080212.ca4be1f6.rdunlap@xenotime.net>
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
	<20100921151033.80e61747.randy.dunlap@oracle.com>
	<19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
	<4C9A1FB7.9050902@oracle.com>
	<19611.8986.142128.168878@elektron.ikp.physik.tu-darmstadt.de>
	<19611.20403.865248.695829@elektron.ikp.physik.tu-darmstadt.de>
	<20100923080212.ca4be1f6.rdunlap@xenotime.net>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v0.99a by 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.9.23.162116
X-PMX-RELAY: mailout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Randy" == Randy Dunlap <rdunlap@xenotime.net> writes:


    Randy> Is CONFIG_DRM_KMS_HELPER enabled in your kernel .config file?  If
    Randy> not, we need to find out how to enable it (there is no kconfig
    Randy> prompt for it).

Yes, it is enabled

    Randy> Can you check if Alt-Sysrq-H (help) lists V for "force-fb(V)"?
Yes, it is listed.

And yes, my last experiments where with ALT-CTL-sysreq, so doomed for non
function due to operator error.

However:
When running X, X.Org X Server 1.9.0 on Thinkpad R50 RV250, Alt-Sysrq-v
switches to an all-black display. By console switching with ALT-CLT-F1 I
get back to the booting console and ALT-CLT-F7 brings me back to X.  Running
on the console and calling Alt-Sysrq-v prints
 SysRq : Restore framebuffer console

Is there some omission by the distribution or my setup that Alt-Sysrq-v when
running X results in an all-black screen?

And when I hit the hibernate problem, the screen stays black even with a
console switch after Alt-Sysrq-v

Bye
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
