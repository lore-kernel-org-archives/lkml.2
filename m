Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2HGCwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:52:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:27144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab2HGCwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:52:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193999904"
Message-ID: <1344308038.1682.637.camel@rui.sh.intel.com>
Subject: thermal patches in linux-next
From: Zhang Rui <rui.zhang@intel.com>
To: linux-next <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kachhap <amit.kachhap@linaro.org>, guenter.roeck@ericsson.com,
        kuninori.morimoto.gx@renesas.com, akpm@linux-foundation.org
Date: Tue, 07 Aug 2012 10:53:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

I just created a git tree for catching all thermal changes.
http://git.kernel.org/?p=linux/kernel/git/rzhang/linux.git;a=summary
and I also created the next branch, which I'd like to be set for
linux-next inclusion, but don't know how.

And, I just saw that there are a couple of thermal patches in
linux-next, which I think it would be better if they can be re-based on
my next branch first.
For Guenter's and Kuninori's patch, I can take them directly, with few
changes.

Amit,
I really like the idea of generic cpufreq cooling. But can you please
rebase the patches on top of my next branch? the recent thermal changes
will make your patch much cleaner, as we discussed before. :)

thanks,
rui

