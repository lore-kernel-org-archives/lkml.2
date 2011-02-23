Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1BWH4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:56:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:60100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1BWH4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:56:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Tee3ZkuJBf1uHpAF9dQeFy9bnrRa4sWhpasoEaLPkn00DmjucuaO5SWS/aNWB3cnAP
         ALrv1+V+2vmo2NhH+zMw==
MIME-Version: 1.0
In-Reply-To: <20110223075121.GI3379@balbir.in.ibm.com>
References: <20110216031831.571628191@google.com> <4D61D230.907@cn.fujitsu.com>
 <AANLkTinyZSeTQd9t9wCp+LMZ+gGM4H0mZBc+daZgnZ5u@mail.gmail.com> <20110223075121.GI3379@balbir.in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 22 Feb 2011 23:56:20 -0800
Message-ID: <AANLkTi=_iZfr8EGWqwrsm0D_wP6dNdaVDqAq3pS0fbuW@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
To: balbir@linux.vnet.ibm.com
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
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

On Tue, Feb 22, 2011 at 11:51 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
> * Paul Turner <pjt@google.com> [2011-02-22 23:42:48]:
>
>> Thanks for the report Xiao -- I wasn't able to reproduce this yet with
>> a simple guest, I will try a more modern image tomorrow.
>>
>> One suspicion is that this might be connected with the missing
>> runnable accounting in sched_stoptask.c.
>>
>
> I can confirm that, my guests work fine after the changes posted this
> morning. I still see some lockdep errors, but none associated with the
> scheduler.
>

Excellent!

Ok, if this is resolved I'll roll this up and repost tomorrow, thanks!

> --
>        Three Cheers,
>        Balbir
>
