Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab0GNWdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab0GNWde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:33:34 -0400
Message-ID: <4C3E3B3B.40403@redhat.com>
Date: Wed, 14 Jul 2010 18:33:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] Robust TSC compensation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-10-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-10-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 10:25 PM, Zachary Amsden wrote:
> Make the match of TSC find TSC writes that are close to each other
> instead of perfectly identical; this allows the compensator to also
> work in migration / suspend scenarios.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>

I don't see a real alternative, so ...

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
