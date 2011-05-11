Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab1EKQN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:13:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab1EKQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DlA6qkXeCk/y5MuX+pf3a2aXTLXbShN8+EGTDWNEnk6LuZQPK8bwumywW2jy9SwCFR
         /sbk0OsZfsLIy3vdKJOA==
MIME-Version: 1.0
In-Reply-To: <4DC8E93F.1080803@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110503092905.782248242@google.com>
 <4DC8E93F.1080803@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 May 2011 02:09:39 -0700
Message-ID: <BANLkTi=kLczKTOb-7SN1kaPRu+MZFc03fA@mail.gmail.com>
Subject: Re: [patch 15/15] sched: add documentation for bandwidth control
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:29 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/05/03 18:29), Paul Turner wrote:
>> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
>>
>> Basic description of usage and effect for CFS Bandwidth Control.
>>
>> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>> Signed-off-by: Paul Turner <pjt@google.com>
>> ---
>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
> Thank you very much for your great work, Paul!
>
> I've run some test on this version and no problems so far
> (other than minor bug pointed by 04/15).
> Definitely things getting better.
>
> I'll continue tests and let you know if there is something.
>

Thank you for taking the time to review and test!

Very much appreciated!

>
> Thanks,
> H.Seto
>
>
