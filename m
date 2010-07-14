Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0GNTCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab0GNTCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:02:35 -0400
Message-ID: <4C3E09C8.2020806@redhat.com>
Date: Wed, 14 Jul 2010 15:02:32 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/18] Add helper functions for time computation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-9-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-9-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 10:25 PM, Zachary Amsden wrote:
> Add a helper function to compute the kernel time and convert nanoseconds
> back to CPU specific cycles.  Note that these must not be called in preemptible
> context, as that would mean the kernel could enter software suspend state,
> which would cause non-atomic operation.
>
> Also, convert the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls to use the kernel
> time helper, these should be bootbased as well.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
