Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1GFDqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:46:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab1GFDql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:46:41 -0400
Message-ID: <4E13DA8F.9080706@redhat.com>
Date: Tue, 05 Jul 2011 23:46:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 3/9] KVM-HDR: KVM Steal time implementation
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1309793548-16714-4-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 11:32 AM, Glauber Costa wrote:
> To implement steal time, we need the hypervisor to pass the guest information
> about how much time was spent running other processes outside the VM.
> This is per-vcpu, and using the kvmclock structure for that is an abuse
> we decided not to make.
>
> In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
> holds the memory area address containing information about steal time
>
> This patch contains the headers for it. I am keeping it separate to facilitate
> backports to people who wants to backport the kernel part but not the
> hypervisor, or the other way around.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra<peterz@infradead.org>
> CC: Avi Kivity<avi@redhat.com>
> CC: Anthony Liguori<aliguori@us.ibm.com>
> CC: Eric B Munson<emunson@mgebm.net>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
