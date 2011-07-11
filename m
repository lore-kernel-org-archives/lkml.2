Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1GKNTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab1GKNTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:19:36 -0400
Message-ID: <4E1AF85C.2090500@redhat.com>
Date: Mon, 11 Jul 2011 10:19:24 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 4/9] KVM-HV: KVM Steal time implementation
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-5-git-send-email-glommer@redhat.com> <4E1AF64E.6070305@redhat.com> <4E1AF689.7000601@redhat.com>
In-Reply-To: <4E1AF689.7000601@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 10:11 AM, Avi Kivity wrote:
> On 07/11/2011 04:10 PM, Avi Kivity wrote:
>>
>> I think Peter acked this, yes? Please include his acks.
>>
>
> Sorry, I meant this for the kernel/sched.c bits.
>
Yes he did, after I posted the patches.
I will include his acks in the respin, since they won't change the 
scheduler bits.

