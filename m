Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2BFLbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 06:31:12 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:47323 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab2BFLbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 06:31:11 -0500
X-Greylist: delayed 927 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 06:31:11 EST
Date: Mon, 6 Feb 2012 15:18:53 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: No /dev/root with devtmpfs?
Message-ID: <20120206111853.GA11506@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello up there.

Recently I've reworked my system not to use udev, but use devtmpfs
instead and discovered there is no /dev/root symlink in devtmpfs case.

My setup uses /dev/root early to know what is the boot device and then
do some operations on it like checksumming, etc...

Now when /dev/root is gone the best workaround I could come up with is
to   grep /proc/partitions for '[hs]d[a-z]1'  but it's ugly and will
break when there are several block devices attached.


Is it somehow possible to add /dev/root to devtmpfs?


Thanks,
Kirill
