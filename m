Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1FTO1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:27:47 -0400
Received: from ccserver2.unican.es ([130.206.5.101]:57984 "EHLO
	ccserver2.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1FTO1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:27:46 -0400
Message-ID: <4DFF58DD.3040801@unican.es>
Date: Mon, 20 Jun 2011 16:27:41 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: synchronization mechanisms
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18210.007)
X-imss-scores: Clean:6.21862 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello!
As I told you in previous questions I'm developing drivers using the 
2.6.31-11-rt patch under ubuntu 10.04.
It is very important for me to know about which real time 
synchronization mechanisms do I have.
I found the RT-mutexes, with priority inherintance, the plists (priority 
lists) and now I'm looking for more information about semaphores. I 
haven't found anything relevant in the code that I could know that they 
work well under real time, having a priority queue of tasks waiting on 
it. So I've made an easy example where I have 3 kernel threads with 
different priorities each (60,70,80) in the semaphore queue. Then I see 
is always the most priority kthread who wakes up the first. Good! It 
seems to work as a RT semaphore!
In my code I have an error. I can use down_interruptible but I can't use 
down_killable. Why is it?
Could anybody give me some help about semaphores in the rt-patch and 
about any other synchronization mechanism thought for real time?

Thanks a lot

Mónica
