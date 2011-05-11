Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1EKQMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:12:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1EKQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=m+QnHe4IXzv/7MWWAGcmK50v7HqXYGgWBmEGE7anor8/m5Bb+ZALr6mkmUjQ9jOply
         39s8PqntDopHC50JkfYQ==
MIME-Version: 1.0
In-Reply-To: <4DC8E8D7.7060802@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110503092905.517969868@google.com>
 <4DC8E8D7.7060802@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 May 2011 02:10:20 -0700
Message-ID: <BANLkTi=YLHbionpmjTX7-9oLZztYjnkjbA@mail.gmail.com>
Subject: Re: [patch 12/15] sched: migrate throttled tasks on HOTPLUG
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

On Tue, May 10, 2011 at 12:27 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/05/03 18:28), Paul Turner wrote:
>> +#else
>> +static void unthrottle_offline_cfs_rqs(struct rq *rq)
>> +{
>> +}
>> +#endif
>> +
>
> Nit: To follow others, alternative style is in a line:
>
> +static void unthrottle_offline_cfs_rqs(struct rq *rq) {}
>

Agree, updated.  Thanks

> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
>
> Thanks,
> H.Seto
>
>
