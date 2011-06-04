Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1FDMDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 08:03:19 -0400
Received: from ccserver1.unican.es ([130.206.5.100]:55683 "EHLO
	ccserver1.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1FDMDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 08:03:18 -0400
Message-ID: <4DEA1F22.6000603@unican.es>
Date: Sat, 4 Jun 2011 14:03:46 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: I/O operations priority in RTOS
References: <4DEA1BA9.7020303@unican.es>
In-Reply-To: <4DEA1BA9.7020303@unican.es>
Content-Type: text/plain;
	charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18178.007)
X-imss-scores: Clean:94.06621 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm studying how to develop drivers in a real time OS and how do they 
work. I'm using  Ubuntu 10.04 with the 2.6.31-11-rt patch installed.
I would like to know the priority when executing open(), read(), write() 
and close() operations.
In my example the thread which is using the driver runs with 10 RTPRIO, 
but I don't know what happens in kernel context with the priority when 
running the I/O operations.
Thank you for your help, I don't know where to learn about this.

Mónica
