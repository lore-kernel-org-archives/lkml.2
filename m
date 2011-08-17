Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1HQO4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:56:46 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:38012 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1HQO4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:56:43 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Aug 2011 10:56:43 EDT
Message-ID: <4E4BD560.4010806@bootc.net>
Date: Wed, 17 Aug 2011 15:51:12 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: FireWire/SBP2 Target mode
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Now that we have a nice SCSI target framework in the kernel, and drivers 
either in-tree or being worked on for iSCSI, FC, FCoE, SAS and iSER, I 
was wondering about the possibility of adding FireWire to that list. 
Apple Macs have had a FireWire Target Disk mode for a long time, and 
there is even a program called Endpoint[1] that apparently does this on 
Linux though it looks completely untouched since 2003 and no longer 
works as it depends on the old FireWire stack.

I would very much like to see something like this added to the kernel, 
and would very much like to contribute to writing this feature. However 
my kernel development knowledge is very limited indeed so this would 
require a lot hand-holding and mentoring.

What's the interest in such a feature? Would anyone be able to give some 
(a lot?) of their time to help write this?

Thanks,
Chris

[1] http://oss.oracle.com/projects/endpoint/

