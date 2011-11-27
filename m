Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1K0MWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:22:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1K0MWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:22:32 -0500
Message-ID: <4ED22B84.1070604@redhat.com>
Date: Sun, 27 Nov 2011 14:22:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: IA64: fix struct redefinition
References: <4ECE17C7.2080801@gmail.com>
In-Reply-To: <4ECE17C7.2080801@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 12:09 PM, Xiao Guangrong wrote:
> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>
> There is the same struct definition in ia64 and kvm common code:
> arch/ia64/kvm//kvm-ia64.c: At top level:
> arch/ia64/kvm//kvm-ia64.c:777:8: error: redefinition of ‘struct kvm_io_range’
> include/linux/kvm_host.h:62:8: note: originally defined here
>
> So, rename kvm_io_range to kvm_ia64_io_range in ia64 code
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

