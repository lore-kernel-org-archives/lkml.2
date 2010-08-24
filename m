Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0HXNPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:15:14 -0400
Received: from blu0-omc3-s30.blu0.hotmail.com ([65.55.116.105]:19643 "EHLO
	blu0-omc3-s30.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585Ab0HXNPL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:15:11 -0400
Message-ID: <BLU102-W1030ED196ED7B94722F2A7EB830@phx.gbl>
X-Originating-IP: [217.140.96.21]
From: Raj Kumar <rajkumar278@hotmail.com>
To: <stern@rowland.harvard.edu>
CC: <linux-kernel@vger.kernel.org>
Subject: Runtime power management during system resume
Date: Tue, 24 Aug 2010 18:45:10 +0530
Importance: Normal
In-Reply-To: <Pine.LNX.4.44L0.1008231716430.1601-100000@iolanthe.rowland.org>
References: <4C72D1BD.4060503@kernel.dk>,<Pine.LNX.4.44L0.1008231716430.1601-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 Aug 2010 13:15:10.0366 (UTC) FILETIME=[61195BE0:01CB438E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
Hi Alan,
 
I have implemented the run time power management in my drivers. I have one
issue regarding System resume.
 
When the system sleep is triggered as it is mentioned that Power management
core will increment the power_usage counter during prepare and decrements when complete
is called.
 
Now I have few questions:
 
1) When the system resume is done, it does not increase the power_usage counter.
 right?
 
So Does then the driver need to update the power_usage counter with run time power management
core and again set it to active means RPM_ACTIVE?
 
2) Suppose device is active, means its power_usage counter is already one, Now during system
sleep, does the driver first suspend it with run time power management core and then continue
System suspend?
 
3) Because I have seen the code of power management core and I did not see the that during
system suspend, run time power management status is updated means RPM_SUSPENDED.
right?
 
What do you think?
 
Regards
Raj
 
  		 	   		  