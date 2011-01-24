Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1AXXPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:15:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1AXXPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:15:16 -0500
Message-ID: <4D3E07F9.1010601@redhat.com>
Date: Mon, 24 Jan 2011 18:15:05 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 12/16] KVM-HV: KVM Steal time implementation
References: <1295892397-11354-1-git-send-email-glommer@redhat.com> <1295892397-11354-13-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-13-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 01:06 PM, Glauber Costa wrote:
> To implement steal time, we need the hypervisor to pass the guest information
> about how much time was spent running other processes outside the VM.
> This is per-vcpu, and using the kvmclock structure for that is an abuse
> we decided not to make.
>
> This patch contains the hypervisor part for it. I am keeping it separate from
> the headers to facilitate backports to people who wants to backport the kernel
> part but not the hypervisor, or the other way around.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra<peterz@infradead.org>
> CC: Avi Kivity<avi@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>
