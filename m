Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab1CPNpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:45:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39646 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750838Ab1CPNpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:45:13 -0400
Content-Type: text/plain; charset="utf-8"
Date: Wed, 16 Mar 2011 14:45:10 +0100
From: sctp@muskelshirt.de
Message-ID: <20110316134510.64770@gmx.net>
MIME-Version: 1.0
Subject: poor sctp performance with small packets 
To: linux-kernel@vger.kernel.org
X-Authenticated: #113584424
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+KMfhdfQiKNXE9f/cgaV4pUwH8oTQoM4zaW3uh1l
 bKq4y66eO+y9dzLA+4DkDL9YHIfu9UydqsDg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: gNroAHZ4bHIhIFoR/DI0qQciJihyapCh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am just trying iperf 2.0.8 with the "-z" option - packet size is 1 Byte.
(With my own tool the results are the same)
./iperf -s -p 4444  -l 1 -z    (this is the reader)
./iperf -c 172.16.0.1 -l 1 -p 4444  -t 30 -z   (this is the writer)

>From a tcpdump point of view it looks that only each 200ms a packet is sent - so very poor throughput. 

OS is Redhat,
2.6.32-71.18.1.el6.x86_64 #1 SMP Wed Feb 2 17:49:59 EST 2011 x86_64 x86_64 x86_64 GNU/Linux

br




-- 
GMX DSL Doppel-Flat ab 19,99 Euro/mtl.! Jetzt mit 
gratis Handy-Flat! http://portal.gmx.net/de/go/dsl
