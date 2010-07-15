Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0GOCct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145Ab0GOCcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:32:48 -0400
Message-ID: <4C3E734D.2020402@redhat.com>
Date: Wed, 14 Jul 2010 22:32:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/18] Add clock sync request to hardware enable
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-13-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-13-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 10:25 PM, Zachary Amsden wrote:
> If there are active VCPUs which are marked as belonging to
> a particular hardware CPU, request a clock sync for them when
> enabling hardware; the TSC could be desynchronized on a newly
> arriving CPU, and we need to recompute guests system time
> relative to boot after a suspend event.
>
> This covers both cases.
>
> Note that it is acceptable to take the spinlock, as either
> no other tasks will be running and no locks held (BSP after
> resume), or other tasks will be guaranteed to drop the lock
> relatively quickly (AP on CPU_STARTING).

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
