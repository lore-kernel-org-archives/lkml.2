Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2CEBqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:46:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37430 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab2CEBqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:46:15 -0500
X-AuditID: cbfee60f-b7bd0ae00000422c-fc-4f541adfa2c7
Date: Mon, 05 Mar 2012 01:46:07 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: linux-next: build failure after merge of the cpufreq tree
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "RafaelJ.Wysocki<rjw"@sisk.pl, linux-pm@vger.kernel.org
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120305014118270@myungjoo.ham
Msgkey: 20120305014118270@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120305014118270@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <13197479.540821330911965933.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q251kOuA028935

Hello,

The patch "CPUfreq ondemand: handle QoS request on DVFS response latency" that introduced the mentioned errors requires the patch "PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency" get merged, too. I guess that patch will be at pm-qos tree if get merged (v2 patch has been released 7 days ago).


Cheers!
MyungJoo.

------- Original Message -------
Sender : Stephen Rothwell<sfr@canb.auug.org.au>
Date : 2012-03-01 11:56 (GMT+09:00)
Title : linux-next: build failure after merge of the cpufreq tree

Hi Dave,

After merging the cpufreq tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/cpufreq/cpufreq_ondemand.c: In function 'cpufreq_gov_dbs_init':
drivers/cpufreq/cpufreq_ondemand.c:880:28: error: 'PM_QOS_DVFS_RESPONSE_LATENCY' undeclared (first use in this function)
drivers/cpufreq/cpufreq_ondemand.c: In function 'cpufreq_gov_dbs_exit':
drivers/cpufreq/cpufreq_ondemand.c:896:25: error: 'PM_QOS_DVFS_RESPONSE_LATENCY' undeclared (first use in this function)

Caused by commit 500e8ca39c56 ("[CPUFREQ] ondemand: handle QoS request on
DVFS response latency").

I have used the cpufreq tree fomr next-20120229 for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/



--
MyungJoo Ham (ÇÔ¸íÁÖ), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
