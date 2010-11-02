Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0KBJ0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 05:26:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab0KBJZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 05:25:59 -0400
Message-ID: <4CCFDA28.4070003@cn.fujitsu.com>
Date: Tue, 02 Nov 2010 17:30:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
References: <4CCE8143.3090105@cn.fujitsu.com> <4CCE82BC.3090000@cn.fujitsu.com> <20101101125551.GD31722@redhat.com> <4CCF77B2.9080604@cn.fujitsu.com> <20101102065613.GA7881@redhat.com> <4CCFBE4E.3090804@cn.fujitsu.com> <20101102074545.GC7881@redhat.com> <4CCFD556.3070504@cn.fujitsu.com> <20101102091430.GD7881@redhat.com>
In-Reply-To: <20101102091430.GD7881@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 05:14 PM, Gleb Natapov wrote:

> If irqchip is in userspace apf is disabled (see mmu.c:can_do_async_pf()).
> The reason for this is that when irqchip_in_kernel(v->kvm) cpu sleeps in
> userspace during halt, so all event that can cause it to be unhalted
> should be generated in userspace too. This is also the reason you can't have
> pit in kernel and irqchip in userpsace.
> 

Oh, thank you very much for answering so many questions, and your patch is
looks good for me! ;-)
