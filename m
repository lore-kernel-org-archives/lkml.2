Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2BPPxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:53:10 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59236 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2BPPxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:53:08 -0500
From: Pradeep Kumar <psuriset@linux.vnet.ibm.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Cc: Pradeep Kumar <psuriset@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 21:22:48 +0530
Message-Id: <20120216155248.6865.47935.sendpatchset@localhost.localdomain>
Subject: Re: KVM: perf: a smart tool to analyse kvm events
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021615-7182-0000-0000-000000CF64E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao,

 i tried your perf events patch set on RHEL 6.1 host and failed to trace kvm-events with below error message.

  [root@kvm perf]# ./perf kvm-events report
  Warning: unknown op '{'
  Warning: Error: expected type 5 but read 1
  Warning: failed to read event print fmt for hrtimer_start
  Warning: unknown op '{'
  Warning: Error: expected type 5 but read 1
  Warning: failed to read event print fmt for hrtimer_expire_entry
  Analyze events for all VCPUs:
  VM-EXIT    Samples  Samples%     Time%         Avg time               
  Total Samples:0, Total events handled time:0.00us.
  [root@kvm perf]#          
	     
    --Pradeep

