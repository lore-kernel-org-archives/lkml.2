Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1B1NaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:30:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1B1NaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:30:10 -0500
Message-ID: <4D6BA35E.6060504@redhat.com>
Date: Mon, 28 Feb 2011 15:30:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] expose kvmclock upper msr set.
References: <1298483054-1665-1-git-send-email-glommer@redhat.com>	 <4D6A409E.9010107@redhat.com> <1298899495.15736.321.camel@mothafucka.localdomain>
In-Reply-To: <1298899495.15736.321.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 03:24 PM, Glauber Costa wrote:
> On Sun, 2011-02-27 at 14:16 +0200, Avi Kivity wrote:
> >  On 02/23/2011 07:44 PM, Glauber Costa wrote:
> >  >  We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
> >  >  for a while now, but we're not exposing it yet, meaning nobody is using it.
> >  >  This simple patch takes care of that.
> >
> >  We're exposing them via KVM_GET_SUPPORTED_CPUID, leaf KVM_CPUID_FEATURES.
> >
> Our userspace does not really use it, and rely on the capability list.
> Historically, we've been relying on the capabilities mechanism to
> indicate what exists and what does not.

Yes.  I believe this bit marked the change point.

Anyway, it's exposed, and it's a lot better for userspace to make use of 
KVM_GET_SUPPORTED_CPUID since it will work on more kernels.

-- 
error compiling committee.c: too many arguments to function

