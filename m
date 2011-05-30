Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1E3GKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:10:05 -0400
Received: from mailhost-c1-p0.netultra.net ([195.5.209.9]:60137 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823Ab1E3GKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:10:04 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 May 2011 02:10:04 EDT
Date: Mon, 30 May 2011 07:59:24 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Very high CPU load when idle with 3.0-rc1
Message-ID: <20110530055924.GA9169@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Testing 3.0-rc1 on a core i7 (4 cores + HT), I get a load average of 9.0
when idle. No process is shown running or in "D state" in htop. The box
is behaving normal, no impression of lag or slowness.

Not sure what other info to include, I guess this should be quite easy
to reproduce.

Best,
-- 
Damien Wyart
