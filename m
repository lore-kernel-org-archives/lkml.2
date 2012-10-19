Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab2JSX2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:28:03 -0400
Received: from smtp.getmail.no ([84.208.15.66]:36976 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab2JSX2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:28:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <op.wmbjpvqe6426ze@localhost.localdomain>
References: <op.wmbjpvqe6426ze@localhost.localdomain>
Subject: re: Optimizing scheduling policies for Ubuntu (desktop),
 for low-jitter.
To: linux-kernel@vger.kernel.org
Date: Sat, 20 Oct 2012 01:27:57 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wmf8svxp6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not many are discussing this.

So odd since an overloaded computer, looks like a computer with jitter. So  
removing jitter = higher performance.

I changed X to nice -20 though instead. It is hard to predict jitter, and  
maybe some measure of fairness is good.
Still daemons wouldn`t mind running sequentially as simple round robin,  
or? I would like to see a lowpriority round-robin, and not just the  
realtime one. Maybe a modification on "idle" pri. I just want to know  
daemons can be made transparent to jitter. Or atleast some measure of  
fairness to sequentialness that keeps the lowest jitter.

Anyone following ? :)

Peace Be With You.
