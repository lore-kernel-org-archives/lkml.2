Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1KAHDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:03:31 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:39252 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1KAHDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:03:30 -0400
Message-ID: <4EAF99BD.1010203@t-online.de>
Date: Tue, 01 Nov 2011 08:03:25 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: shemminger@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: sky2: hung mac
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: X7B5ysZBZhLjBjq4ch4q4L7bms1uGeIu59M2kE143ulCvSPUgoAKuR15GrztElRQj0
X-TOI-MSGID: 4ed487f3-298f-4986-9572-71d85a6aaa44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a sky2 "hung mac" message.

grep-ing the logs I realized that this already happened
  two times, but that was about 8 months ago.

system hw: AOpen i915GMm-hfs, Pentium M Dothan 2GB,
                     2 Yukon-2 EC chips, revision 1.
system sw: oct: kernel 3.1.0, running since oct 24.
system sw: oct: latest stable kernel at that time
system is always on.

Feb  3 12:04:24 golem kernel: [21332.000035] sky2 0000:02:00.0: eth0: hung mac 124:123 fifo 195 (165:160)
Feb  3 12:04:24 golem kernel: [21332.000047] sky2 0000:02:00.0: eth0: receiver hang detected
Feb  3 12:04:27 golem kernel: [21334.950762] sky2 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both

Feb  7 20:08:33 golem kernel: [10925.000036] sky2 0000:02:00.0: eth0: hung mac 0:33 fifo 5 (145:155)
Feb  7 20:08:33 golem kernel: [10925.000048] sky2 0000:02:00.0: eth0: receiver hang detected
Feb  7 20:08:36 golem kernel: [10928.060855] sky2 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both

Oct 31 17:55:55 golem kernel: [29826.000040] sky2 0000:02:00.0: eth0: hung mac 8:28 fifo 0 (173:173)
Oct 31 17:55:55 golem kernel: [29826.000083] sky2 0000:02:00.0: eth0: receiver hang detected
Oct 31 17:55:58 golem kernel: [29829.006516] sky2 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both

Is it a sign of a bug or should it simply be ignored?

cu,
  Knut
