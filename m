Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab0JDHvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:51:23 -0400
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:47218 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136Ab0JDHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:51:21 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 03:51:21 EDT
Subject: 2.6.35.6 fails to suspend (pxa2xx-mci.0)
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Mon, 04 Oct 2010 09:30:35 +0200
Message-ID: <1286177435.2140.5.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1286178681;ba17880e;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we are running an embedded system here based on the PXA300 platform.
Suspend/resume used to work well so far. However after upgrading the
kernel from 2.6.34.7 to 2.6.35.6, we get the following error when trying
to suspend the system:

# echo "mem" > "/sys/power/state"
[ 5647.295953] PM: Syncing filesystems ... done.
[ 5647.318792] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 5647.337048] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 5647.356915] Suspending console(s) (use no_console_suspend to debug)
[ 5647.366651] pm_op(): platform_pm_suspend+0x0/0x5c returns -38
[ 5647.366671] PM: Device pxa2xx-mci.0 failed to suspend: error -38
[ 5647.367082] PM: Some devices failed to suspend


Regards,
Sven


-- 
Sven Neumann
Head of Software Development

RAUMFELD GmbH | Reichenberger Str. 124 | 10999 Berlin | Germany
Tel: +49.30.340.60.98.0 | Fax: +49.30.340.60.98.99 | s.neumann@raumfeld.com

