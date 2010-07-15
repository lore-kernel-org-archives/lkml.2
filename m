Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0GOChG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab0GOChC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:37:02 -0400
Message-ID: <4C3E744C.7060402@redhat.com>
Date: Wed, 14 Jul 2010 22:37:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] Fix a possible backwards warp of kvmclock
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-15-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-15-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 10:25 PM, Zachary Amsden wrote:
> Kernel time, which advances in discrete steps may progress much slower
> than TSC.  As a result, when kvmclock is adjusted to a new base, the
> apparent time to the guest, which runs at a much higher, nsec scaled
> rate based on the current TSC, may have already been observed to have
> a larger value (kernel_ns + scaled tsc) than the value to which we are
> setting it (kernel_ns + 0).
>
> We must instead compute the clock as potentially observed by the guest
> for kernel_ns to make sure it does not go backwards.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
