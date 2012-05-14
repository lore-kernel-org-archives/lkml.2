Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2ENIdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:33:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab2ENIc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:32:59 -0400
Message-ID: <4FB0C337.4070105@redhat.com>
Date: Mon, 14 May 2012 11:32:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Remove stale values from ctxt->memop before
 emulation
References: <1336148056-15662-1-git-send-email-joerg.roedel@amd.com> <4FA634A0.8020504@redhat.com> <20120507101225.GH4687@amd.com>
In-Reply-To: <20120507101225.GH4687@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 01:12 PM, Joerg Roedel wrote:
> From e9262f18e90111d32b584084c0b5564cbd728d65 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Mon, 7 May 2012 12:05:28 +0200
> Subject: [PATCH] KVM: X86: convert bsf/bsr instructions to
>  emulate_2op_SrcV_nobyte()
>
> The instruction emulation for bsrw is broken in KVM because
> the code always uses bsr with 32 or 64 bit operand size for
> emulation. Fix that by using emulate_2op_SrcV_nobyte() macro
> to use guest operand size for emulation.
>
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

