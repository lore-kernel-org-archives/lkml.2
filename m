Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1CFMg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:36:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1CFMg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:36:26 -0500
Message-ID: <4D737FC3.9090801@redhat.com>
Date: Sun, 06 Mar 2011 14:36:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: improve comment on rcu use in irqfd_deassign
References: <20110306110326.GA23818@redhat.com>
In-Reply-To: <20110306110326.GA23818@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 01:03 PM, Michael S. Tsirkin wrote:
> The RCU use in kvm_irqfd_deassign is tricky: we have rcu_assign_pointer
> but no synchronize_rcu: synchronize_rcu is done by kvm_irq_routing_update
> which we share a spinlock with.
>
> Fix up a comment in an attempt to make this clearer.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

