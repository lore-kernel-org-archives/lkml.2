Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0EFIvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab0EFIvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:51:20 -0400
Message-ID: <4BE28304.9090005@redhat.com>
Date: Thu, 06 May 2010 11:51:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Important fixes for KVM-AMD
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 05:04 PM, Joerg Roedel wrote:
> Hi Avi, Marcelo,
>
> here is a set of patches which fix problems in kvm-amd. Patch 1 fixes a
> stupid problem with the event-reinjection introduced by me in my
> previous patchset.  Patch 2 was a helper to find the bug patch 3 fixes.
> I kept it in the patchset because it may be helpful in the future to
> debug other problems too. Patch 3 is the most important fix because it
> makes kvm-amd on 32 bit hosts work again.  Without this patch the first
> vmrum fails with exit-reason VMEXIT_INVALID. Patch 4 fixes the Xen 4.0
> shipped with SLES11 in nested svm. The last patch in this series fixes a
> potential l2-guest breakout scenario because it may be possible for the
> l2-guest to issue hypercalls directly to the host if the l1-hypervisor
> does not intercept VMMCALL.
>    

All applied, thanks.

-- 
error compiling committee.c: too many arguments to function

