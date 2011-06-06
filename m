Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1FFLrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:47:05 -0400
Received: from ccserver2.unican.es ([130.206.5.101]:48091 "EHLO
	ccserver2.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1FFLrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:47:02 -0400
Message-ID: <4DECBE44.2070803@unican.es>
Date: Mon, 6 Jun 2011 13:47:16 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Changing Kernel thread priorities
References: <4DEA1BA9.7020303@unican.es> <4DEA1F22.6000603@unican.es> 
	<4DEA255B.2050503@unican.es>
In-Reply-To: <4DEA255B.2050503@unican.es>
Content-Type: text/plain;
	charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18182.006)
X-imss-scores: Clean:45.15099 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am writing a driver which has one kernel thread associated with it.
I want to change the priority of this thread, so that I can specify the 
order in which it is scheduled following an interrupt.
I'm using:

  sched_setscheduler(struct task_struct *, int, struct sched_param *);

but it doesn't work. I tried to change the priority from the 
init_module, and also from the Kernel Thread, but there is no way.

Kernel version is 2.6.31-11-rt

What do I call to change a kernel thread priority?

Thanks you very much

Mónica

