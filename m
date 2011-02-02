Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1BBKJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:09:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab1BBKJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:09:28 -0500
Message-ID: <4D492D49.6010408@redhat.com>
Date: Wed, 02 Feb 2011 12:09:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 2/6] KVM-HV: KVM Steal time implementation
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>	 <1296244340-15173-3-git-send-email-glommer@redhat.com>	 <4D4563EB.3000203@redhat.com>	 <1296575320.5081.8.camel@mothafucka.localdomain>	 <4D483E43.5060904@redhat.com> <1296590310.5081.136.camel@mothafucka.localdomain>
In-Reply-To: <1296590310.5081.136.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 09:58 PM, Glauber Costa wrote:
> >
> >  Guest reads version (result: 2)
> >  Guest starts reading data
> >  Live migration; vcpu->arch.sversion is zeroed
> >  Steal time update; vcpu->arch.sversion += 2; write to guest
> >  Guest continues reading data
> >  Guest reads version (result: 2)
> >
> >  So the guest is unaware that an update has occurred while it was reading
> >  the data.
> Ok, fair.
>
> By the way, kvmclock have the same problem, then
>

It needs the same fix then.


-- 
error compiling committee.c: too many arguments to function

