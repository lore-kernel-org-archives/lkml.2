Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0GZHup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:50:45 -0400
Received: from centrinvest.ru ([94.25.115.130]:50198 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab0GZHun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:50:43 -0400
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jul 2010 03:50:43 EDT
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Mon, 26 Jul 2010 11:39:20 +0400
To: linux-kernel@vger.kernel.org
Cc: e1000-devel@lists.sourceforge.net,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Subject: Problem with e1000e, 802.1Q VLAN's and IPMI
Message-ID: <20100726073920.GD30155@centrinvest.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	e1000-devel@lists.sourceforge.net,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Alex Duyck <alexander.h.duyck@intel.com>,
	PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
	John Ronciak <john.ronciak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a problem using IPMI on Super Micro X7SBL motherboard (AOC-IPMI20-E BMC).
BMC shares ethernet port with onboard e1000e. It works when IPMI traffic is 
untagged (CrcStripping=0 module option used), but if I try to use 802.1Q vlan
for IPMI traffic BMC stops responding right after "ifup eth0". 
I tested 2.6.26 (debian stable kernel) and 2.6.35-rc6.
Looks like there is some problem with 802.1Q tags stripping/inserting.

There was no such problem with e1000 driver from 2.6.18.

Unfortunately I can't provide additional info right now, but I can provide
it slightly later and I'm ready to test patches.

Best regards.
