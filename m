Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1ATFkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:40:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:41187 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab1ATFkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:40:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] kexec: include sysctl to disable
Date: Thu, 20 Jan 2011 05:32:50 +0000 (UTC)
Message-ID: <ih8he2$41t$2@dough.gmane.org>
References: <20110119222630.6755.63928.stgit@paris.rdu.redhat.com>
	<ih8gpe$41t$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kexec@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 05:21:50 +0000, WANG Cong wrote:

> On Wed, 19 Jan 2011 17:26:30 -0500, Eric Paris wrote:
> 
>> much like /proc/sys/kernel/modules_disable is used to disable module
>> loading, /proc/sys/kernel/kexec_disable is used to disable kexec code
>> loading.  It would still be possible to use kexec -l to load a kernel,
>> set the tunable to 1 so the kernel waiting to boot couldn't change, and
>> then launch the kernel at a later time (through kexec -e or through a
>> crash)
>> 
>> 
> But root can still change it to 0 and do kexec like normal, right?

Er... never mind, it is a one-way road...

Looks like a good balance between reusing CAP_SYS_MODULE and introducing
a new CAP_SYS_XXX.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

