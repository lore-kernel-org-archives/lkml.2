Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0LTLHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 06:07:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0LTLHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 06:07:12 -0500
Message-ID: <4D0F38CB.50801@redhat.com>
Date: Mon, 20 Dec 2010 13:06:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>	 <1292834372.8948.27.camel@marge.simson.net> <4D0F1794.3010803@redhat.com>	 <1292835302.8948.35.camel@marge.simson.net> <4D0F1BD8.20601@redhat.com>	 <1292837440.8948.60.camel@marge.simson.net> <4D0F25E8.80305@redhat.com>	 <1292841193.11946.36.camel@marge.simson.net> <4D0F3266.90908@redhat.com>	 <1292842010.11946.39.camel@marge.simson.net>  <4D0F34C0.9000400@redhat.com> <1292842243.11946.40.camel@marge.simson.net>
In-Reply-To: <1292842243.11946.40.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 12:50 PM, Mike Galbraith wrote:
> >
> >  >  >   >   Would a kick/hint option be useful?
> >  >  >
> >  >  >   Depends on what it does...
> >  >
> >  >  Let you decide whether you only want to drop a hint and leave it at
> >  >  that, or also attempt a preemption.
> >
> >  Who is "you" in this?  the scheduler?
>
> The caller.
>

I guess it works.  We can start out without preemption, if we see we 
spin to much, preempt.

-- 
error compiling committee.c: too many arguments to function

