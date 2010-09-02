Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0IBUiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:38:12 -0400
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:53719 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab0IBUiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:38:10 -0400
Message-ID: <4C800B06.90005@genband.com>
Date: Thu, 02 Sep 2010 14:37:26 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: fuse-devel@lists.sourceforge.net, axboe@kernel.dk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ionice and FUSE-based filesystems?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2010 20:37:28.0104 (UTC) FILETIME=[A88A9280:01CB4ADE]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17612.000
X-TM-AS-Result: No--9.454600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm curious about the limits of using ionice with multiple layers of
filesystems and devices.

In particular, we have a scenario with a FUSE-based filesystem running
on top of xfs on top of LVM, on top of software RAID, on top of spinning
disks.  (Something like that, anyways.)  The IO scheduler is CFQ.

In the above scenario would you expect the IO nice value of the writes
done by a task to be propagated all the way down to the disk writes?  Or
would they get stripped off at some point?

Thanks,
Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
