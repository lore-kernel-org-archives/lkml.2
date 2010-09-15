Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0IORpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:45:42 -0400
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:52614 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847Ab0IORpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:45:41 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 13:45:40 EDT
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
Date: Wed, 15 Sep 2010 19:40:37 +0200
To: linux-kernel@vger.kernel.org
Subject: Any SYSRQ key to force mode switch to console mode when using KMS?
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v0.99a by 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.9.15.173014
X-PMX-RELAY: mailout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

is there any SYSRQ key that forces the video system to console mode,
especially when using KMS and allows to work on. 

Since going to KMS on a Thinkpad R50 with ATI Radeon RV250 via going from
Opensuse-11.2 to Opensuse-11.3 I experience frequent situations where I am
left with a black screen, with only ALT-SYSREQ-C switching the screen back
on and hard reboot as only chance to escape that situation.

Situations that result in a black screen are:

* Going with the mouse over the NOSCRIPT buttom in firefox. Load goes up and
screen goes black after some seconds. xorg.log ends with "Backtrace", but no
backtrace output...

* Calling pm-hibernate on a system that has hibernated before. First
  pm-hibernate/wake-up-per power buttom sequence is successfull.

Disabling KMS results in very slow "kaffeine" full screen output...

pm-hibernate and firefox/noscript worked pre-KMS on opensuse-11.2.

Some traces of other people hitting the NOSCRIPT xorg crash and others
hitting the black unresponsive screen with KMS on RV250 are
found on the net, but I didn't find a conclusive resolution.

Opensuse default kernel and the recent Opensuse 2.6.36-rc3 kernel-of-the day
were tested with no difference

Thanks

PS: I only follow linux-kernel via gmane.org, so if you need fast feedback,
please CC me. 
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
