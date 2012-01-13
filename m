Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2AMHpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 02:45:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47841 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2AMHpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 02:45:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAJSP0QW1S87WD2pHZ0xUxTvxpOAxsB-LyOD4skxxziwUCWtkkQ@mail.gmail.com>
References: <CAFgQCTtQfVXrgS-eP0-58T+Qx4fHJ6nB6qHXKSEsHDTc2zC2nA@mail.gmail.com>
	<CAJSP0QW1S87WD2pHZ0xUxTvxpOAxsB-LyOD4skxxziwUCWtkkQ@mail.gmail.com>
Date: Fri, 13 Jan 2012 15:45:06 +0800
Message-ID: <CAFgQCTvtkSxXq_v6X6VW+k83rDHBiHC0HwupXBg+fSMJ-VdoSA@mail.gmail.com>
Subject: Re: Could anybody give some description about the implement of
 hyercall in kvm?
From: Liu ping fan <kernelfans@gmail.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 5:21 PM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Thu, Jan 12, 2012 at 4:38 AM, Liu ping fan <kernelfans@gmail.com> wrote:
>> Could anybody give some description about the implement of hyercall in
>> kvm? Or give some links about it?
>
> Try git grep hypercall arch/x86/kvm.
>
> Take a look at arch/x86/kvm/x86.c kvm_set_msr_common() and
> kvm_emulate_hypercall().  Some of the KVM time-keeping, minimal HyperV
> support, and async page faults live there.  Also see
> arch/x86/include/asm/kvm_para.h.
>
> Hypercalls are architecture-specific so if you are interested in ppc
> or s390, check those arch directories.
>
Thanks, but when I tried to start from the macro "____PVOP_VCALL", but
lost in it. If there is some document like the hypercall in Xen, this
will be appreciated. (And I guest Hypercall in kvm is the same as Xen
which is very similar to syscall, right?)

Thanks
ping fan

> Stefan
