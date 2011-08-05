Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1HEMJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:09:06 -0400
Received: from rrzmta5.uni-regensburg.de ([194.94.155.56]:40787 "EHLO
	rrzmta5.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1HEMJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:09:05 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 08:09:05 EDT
Message-Id: <4E3BF809020000A100006CDF@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 05 Aug 2011 14:02:49 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: cat /proc/mdstat blocking?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I thought that /proc/mdstat just displays the current state of the MD RAIDs, not querying them, thus never blocking. Unfortunately I could observer a "cat /proc/mdstat" hanging for several seconds when one of the RAID1 legs was unavailable and multipathd was queueing requests to the leg.

Practically this makes monitoring of the other RAIDs difficult when one bad device is enough to block /proc/mdstat.

Now my question: Does it work as designed (i.e. as intended), or is this not as intended?

As I'm not subcribed to the kernel list, maybe CC: your replies.

Effect was observed in SLES11 SP1 x86_64 with multipathed FC SAN disks (2.6.32.36) on a machine with several CPUs.

Regards,
Ulrich Windl


