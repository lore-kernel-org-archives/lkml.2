Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1C3PYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:24:50 -0400
Received: from smtpbg52.qq.com ([64.71.138.43]:40172 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753728Ab1C3PYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:24:49 -0400
X-QQ-mid: esmtp1t1301498606t619t04275
X-QQ-SSF: 00000000000000F0FG400F000000000
Date: Wed, 30 Mar 2011 23:23:30 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: cfq-iosched.c:Use cfqq->nr_sectors in charge the vdisktime
Message-ID: <201103302323256090890@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
      I find the weight policy can be more accuracy with cfqq->nr_sectors instead
of cfqq->slice_dispatch. 
      Today, I try to modify cfq_group_served(), and use "charge = cfqq->nr_sectors; "
instead of "charge = cfqq->slice_dispatch; " . The test result seens more accuracy.
Why you choose slice_dispatch here? Is the nr_sectors will lower the total performance?
      And in iops mod, if I try to apply weight policy on two IO processes with different 
avgrq-sz, the test results will not exact match the weight value.

Thanks
Lina

