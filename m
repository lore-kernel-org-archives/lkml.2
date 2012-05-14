Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2ENI2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:28:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab2ENI2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:28:18 -0400
Message-ID: <4FB0C21D.5030300@redhat.com>
Date: Mon, 14 May 2012 11:28:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: unlike vmcs on fail path
References: <4FB0AD32.6020104@linux.vnet.ibm.com>
In-Reply-To: <4FB0AD32.6020104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 09:58 AM, Xiao Guangrong wrote:
> fix:
>
> [ 1529.577273] Call Trace:
> [ 1529.577289]  [<ffffffffa060d58f>] kvm_arch_hardware_disable+0x13/0x30 [kvm]
> [ 1529.577302]  [<ffffffffa05fa2d4>] hardware_disable_nolock+0x35/0x39 [kvm]
> [ 1529.577311]  [<ffffffffa05fa29f>] ? cpumask_clear_cpu.constprop.31+0x13/0x13 [kvm]
> [ 1529.577315]  [<ffffffff81096ba8>] on_each_cpu+0x44/0x84
> [ 1529.577326]  [<ffffffffa05f98b5>] hardware_disable_all_nolock+0x34/0x36 [kvm]
> [ 1529.577335]  [<ffffffffa05f98e2>] hardware_disable_all+0x2b/0x39 [kvm]
> [ 1529.577349]  [<ffffffffa05fafe5>] kvm_put_kvm+0xed/0x10f [kvm]
> [ 1529.577358]  [<ffffffffa05fb3d7>] kvm_vm_release+0x22/0x28 [kvm]
>
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

