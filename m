Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0IVJoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:44:34 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:58016 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427Ab0IVJod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:44:33 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
Date: Wed, 22 Sep 2010 11:44:26 +0200
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
In-Reply-To: <20100921151033.80e61747.randy.dunlap@oracle.com>
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
	<20100921151033.80e61747.randy.dunlap@oracle.com>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v0.99a by 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.9.22.93618
X-PMX-RELAY: mailout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Randy" == Randy Dunlap <randy.dunlap@oracle.com> writes:

    Randy> On Wed, 15 Sep 2010 19:40:37 +0200 Uwe Bonnes wrote:
    >> Hello,
    >> 
    >> is there any SYSRQ key that forces the video system to console mode,
    >> especially when using KMS and allows to work on.

    Randy> sysrq-v help message says:

    Randy> force-fb(V) = "Restore framebuffer console"

How is that documented outside the sysrq itself?

/usr/src/linux-2.6.36-rc4-19/Documentation/sysrq.txt:

'v'     - Dumps Voyager SMP processor info to your console

Bye
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
