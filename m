Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1FNRHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:07:54 -0400
Received: from nm11-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.240]:34174 "HELO
	nm11-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752015Ab1FNRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:07:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 368593.15429.bm@omp1021.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=4RJve5k4kkIVyCPN3MD0N6gDo0CNXGjTA/9fBBI619lH5WNSEKdUeANaE1wpQN+sPUxzcjur0ZeSw4u0oy9ZngjE/b/lbDYRxBn3nKA6Kucv4I+lwLeu5OcGEaplVNgEWJJOSSNP3bzEgFVsNtGoLIS+6Lf+ONYB3yfTiMsw5g0=;
Message-ID: <80098.5633.qm@web111013.mail.gq1.yahoo.com>
X-YMail-OSG: WXPQ21AVM1l0SV.bkOp.q3YVRGUJEYPTNN6.osW1Mjf2576
 OIg_pogorYUK92PJOczJk64R6WFgGDR1xRgZ58pLsUkUd02xfnjVvO91eszP
 s4kTLgU1B1jUvhfwyAeCxcbbM7l83VrTSzVZBztxaurofC2iVB6bYLKWPyo2
 kYKmuvMQC6IFzvIHtc2C7w.15Er4aeCQPSWueSHrUQiNUNOOjrzeXV7FpbWl
 tyRvG3tYfvevH.9JujJfN2JGXJ93TGKPnNiUGsHHOQfTv0H7w9etu1CmRea.
 KHJkuRGa3WLOo_uoMAjWD0rS4EblRlh21oOSJp6_e67LwtYU8mA--
X-Mailer: YahooMailClassic/14.0.1 YahooMailWebService/0.8.111.304355
Date: Tue, 14 Jun 2011 10:07:50 -0700 (PDT)
From: Andrew Watts <akwatts@ymail.com>
Subject: [OOPS] 2.6.39.x latencytop
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

latencytop 0.5 on a p4 in kernels 2.6.39/2.6.39.1 gives me
the following oops:

------------[ cut here ]------------
WARNING: at kernel/trace/trace.c:2725 tracing_ctrl_write+0x114/0x123()
Pid: 1797, comm: latencytop Not tainted 2.6.39 #2
Call Trace:
[<c10338d4>] warn_slowpath_common+0x67/0x8e
[<c108df49>] ? tracing_ctrl_write+0x114/0x123
[<c108df49>] ? tracing_ctrl_write+0x114/0x123
[<c1033977>] warn_slowpath_fmt+0x2e/0x30
[<c108df49>] tracing_ctrl_write+0x114/0x123
[<c10d61b1>] ? rw_verify_area+0x5d/0x101
[<c10d6574>] vfs_write+0x8c/0x14f
[<c108de35>] ? tracing_release+0x73/0x73
[<c10d66e5>] sys_write+0x3d/0x6b
[<c1590e93>] sysenter_do_call+0x12/0x22
[<c158007b>] ? tg3_get_invariants+0xd0/0x209c 
[<c1580000>] ? tg3_get_invariants+0x55/0x209c
---[ end trace 6f3260379750d0f0 ]---

~ Andy

