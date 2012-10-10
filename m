Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2JJSNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:13:39 -0400
Received: from smtp.getmail.no ([84.208.15.66]:53627 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab2JJSNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Date: Wed, 10 Oct 2012 20:13:25 +0200
Subject: Scheduler queues for less os-jitter?
To: linux-kernel@vger.kernel.org
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wly58nr56426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just wondering, have you considered this?

If daemons are contributing to os-jitter, wouldn`t having them all on  
their own queue reduce jitter? So people could have the stuff like in  
Ubuntu they want, without affecting jitter, or needing stuff like Tiny  
Core, for tiny jitter?

So you get (simplified) something like mainapp - process1 in queue 2,  
mainapp - process2 in queue 2, mainapp - process 3 in queue 2, etc.

Or is that already batch maybe, lol.

Peace Be With You.
