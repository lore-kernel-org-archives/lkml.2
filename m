Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0GMVdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:33:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab0GMVde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:33:34 -0400
Message-ID: <4C3CDBAB.209@redhat.com>
Date: Tue, 13 Jul 2010 17:33:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/18] Make TSC offset writes non-preemptible
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-2-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 10:25 PM, Zachary Amsden wrote:
> Ensure that the storing of the offset and the reading of the TSC
> are never preempted by taking a spinlock.  While the lock is overkill
> now, it is useful later in this patch series.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
