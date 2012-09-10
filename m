Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab2IJJJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:09:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab2IJJJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:09:12 -0400
Message-ID: <504DAE34.1060402@redhat.com>
Date: Mon, 10 Sep 2012 12:09:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: trace the events of mmu_notifier
References: <50499123.70609@linux.vnet.ibm.com>
In-Reply-To: <50499123.70609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 09:16 AM, Xiao Guangrong wrote:
> mmu_notifier is the interface to broadcast the mm events to KVM, the
> tracepoints introduced in this patch can trace all these events, it is
> very helpful for us to notice and fix the bug caused by mm

There is nothing kvm specific here.  Perhaps this can be made generic
(with a mm parameter so we can filter by process).


-- 
error compiling committee.c: too many arguments to function
