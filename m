Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2BQCfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:35:46 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:51211 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BQCfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:35:45 -0500
Message-ID: <4F3DBCD8.2020505@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 10:35:04 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Pradeep Kumar <psuriset@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: KVM: perf: a smart tool to analyse kvm events
References: <20120216155248.6865.47935.sendpatchset@localhost.localdomain>
In-Reply-To: <20120216155248.6865.47935.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021616-1618-0000-0000-000000D3407C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 11:52 PM, Pradeep Kumar wrote:

> Xiao,
> 
>  i tried your perf events patch set on RHEL 6.1 host and failed to trace kvm-events with below error message.
> 
>   [root@kvm perf]# ./perf kvm-events report
>   Warning: unknown op '{'
>   Warning: Error: expected type 5 but read 1
>   Warning: failed to read event print fmt for hrtimer_start
>   Warning: unknown op '{'
>   Warning: Error: expected type 5 but read 1
>   Warning: failed to read event print fmt for hrtimer_expire_entry
>   Analyze events for all VCPUs:
>   VM-EXIT    Samples  Samples%     Time%         Avg time               
>   Total Samples:0, Total events handled time:0.00us.
>   [root@kvm perf]#          
> 	     


Thanks for your try, Pradeep!

It seems that kvm events do not be recorded.

Do your guest was running when kvm-events was executed?
What is the output of "./perf script | grep kvm_*"?

