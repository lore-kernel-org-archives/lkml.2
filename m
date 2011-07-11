Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1GKNKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:10:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1GKNKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:10:50 -0400
Message-ID: <4E1AF64E.6070305@redhat.com>
Date: Mon, 11 Jul 2011 16:10:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 4/9] KVM-HV: KVM Steal time implementation
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1309793548-16714-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 06:32 PM, Glauber Costa wrote:
> To implement steal time, we need the hypervisor to pass the guest
> information about how much time was spent running other processes
> outside the VM, while the vcpu had meaningful work to do - halt
> time does not count.
>
> This information is acquired through the run_delay field of
> delayacct/schedstats infrastructure, that counts time spent in a
> runqueue but not running.
>
> Steal time is a per-cpu information, so the traditional MSR-based
> infrastructure is used. A new msr, KVM_MSR_STEAL_TIME, holds the
> memory area address containing information about steal time
>
> This patch contains the hypervisor part of the steal time infrasructure,
> and can be backported independently of the guest portion.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra<peterz@infradead.org>
> CC: Avi Kivity<avi@redhat.com>
> CC: Anthony Liguori<aliguori@us.ibm.com>
> CC: Eric B Munson<emunson@mgebm.net>

I think Peter acked this, yes?  Please include his acks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

