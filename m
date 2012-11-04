Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2KDJUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 04:20:34 -0500
Received: from smtp.getmail.no ([84.208.15.66]:49203 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2KDJUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:20:31 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <op.wm75y11n6426ze@localhost.localdomain>
References: <op.wly58nr56426ze@localhost.localdomain>
 <1349923594.6989.19.camel@marge.simpson.net>
 <op.wm75y11n6426ze@localhost.localdomain>
Subject: Re: Scheduler queues for less os-jitter?
To: linux-kernel@vger.kernel.org, efault@gmx.de
Date: Sun, 04 Nov 2012 10:20:29 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wm8r8fjw6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, anyway realtime processes did not work quite as expected.  
("overloaded" machine, even though cpu-time is only 10%). So I guess I  
have to enable cgroups and live with the overhead then.

If I set cpu-limits there, does that involve an absolute value, or is it  
normalized, so that even if I do 0.001% cpu for processes, they get all  
cpu, when there is nothing running?

Peace Be With You.
