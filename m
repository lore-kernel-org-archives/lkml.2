Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1BWIFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:05:37 -0500
Received: from smtp-out.google.com ([74.125.121.67]:2515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1BWIFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X4uFPGmvzP5A6+zouC5RQwCbidigSmR2qINfh/5sHRg3/gVOs+jQDIE0WO5Wd5mzwQ
         bU3nUYbXLSoHGOsPQT2w==
MIME-Version: 1.0
In-Reply-To: <20110222031759.GJ10342@balbir.in.ibm.com>
References: <20110216031831.571628191@google.com> <20110216031841.352204682@google.com>
 <20110222031759.GJ10342@balbir.in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 23 Feb 2011 00:05:02 -0800
Message-ID: <AANLkTikX0Hpde2LqdqaVMBAV0G056i-gxXbzWunw6uRK@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 6/7] sched: hierarchical task
 accounting for SCHED_OTHER
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 7:17 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Paul Turner <pjt@google.com> [2011-02-15 19:18:37]:
>
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +/* maintain hierarchal task counts on group entities */
>> +static void account_hier_tasks(struct sched_entity *se, int delta)
>
> I don't like the use of hier, I'd expand it to hierarchical
>

Sure

> I am not too sure about the RT bits, but other than that
>
>
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>
>
> --
>        Three Cheers,
>        Balbir
>
