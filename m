Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2FTOLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:11:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58146 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2FTOLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:11:18 -0400
Date: Wed, 20 Jun 2012 23:11:12 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
Message-Id: <20120620231112.440df9ae19c1aca36100b746@gmail.com>
In-Reply-To: <4FE1CE43.9080203@linux.vnet.ibm.com>
References: <4FE1822D.8010002@linux.vnet.ibm.com>
	<4FE1825B.1030402@linux.vnet.ibm.com>
	<20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp>
	<4FE193AA.8010801@linux.vnet.ibm.com>
	<20120620215653.15930f3467bc13748d548b0d@gmail.com>
	<4FE1CE43.9080203@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 21:21:07 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Again, "rmap" does not break the logic, the spte we handle in this function must
> be in rmap.

I'm not saying whether this breaks some logic or not.

rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
helps developers by saying "rmap_write_protect() protected ...."

For another function, the message should be "another_func_name: spte ..."
But OK, I won't argue about this anymore.

We can change the debug message later if needed.

Thanks,
	Takuya
