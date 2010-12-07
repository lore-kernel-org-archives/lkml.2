Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab0LGJuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:50:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0LGJuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:50:17 -0500
Message-ID: <4CFE0354.6070607@redhat.com>
Date: Tue, 07 Dec 2010 11:50:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] KVM: SVM: Add support for VMCB state caching
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 12:45 PM, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
>
> here is a patch-set which adds support for VMCB state caching to KVM.
> This is a new CPU feature where software can mark certain parts of the
> VMCB as unchanged since the last vmexit and the hardware can then avoid
> reloading these parts from memory.
>
> The feature is implemented downwards-compatible in hardware, so a 0-bit
> means the state has changed and needs to be reloaded. This makes it
> possible to implement the bits without checking for the feature, as done
> in this patch-set (another reason is that the check is as expensive as
> clearing the bit). Processors which do not implement VMCB state
> caching just ignore these bits.
>
> These patches were tested with multiple guests (Windows, Linux, also in
> parallel) and also with nested-svm.
>
> The patches apply on-top of the intercept mask wrapping patch-set I sent
> earlier this week. Your feedback is appreciated.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

