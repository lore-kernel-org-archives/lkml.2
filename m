Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2BBRaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:30:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab2BBRae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:30:34 -0500
Message-ID: <4F2AC818.1000905@redhat.com>
Date: Thu, 02 Feb 2012 19:30:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: x86: move kvm_exit related definitions into
 kvm_exit.h
References: <4F2AC707.7020801@gmail.com> <4F2AC753.4020905@gmail.com>
In-Reply-To: <4F2AC753.4020905@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 07:26 PM, Xiao Guangrong wrote:
> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>
> Move the definitions into a separate .h file so that 'perf kvm-events' can
> easily use these

Why not just include vmx.h and svm.h?  I don't like scattering those
definitions around.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_exit.h |  229 +++++++++++++++++++++++++++++++++++++++

Especially as this file doesn't make a distinction between vmx and svm.


-- 
error compiling committee.c: too many arguments to function

