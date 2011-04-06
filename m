Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1DFC0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 22:26:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16864 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1DFC0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 22:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pwFMIM15dsC1F/ZXAKvD632ds7ZocCYIZWnAnnbgB5oni4YLy6Ddcicva5ZJ1SYyMy
         bADLsRr3wTWrJus0MLZw==
MIME-Version: 1.0
In-Reply-To: <1302010088.2225.1312.camel@twins>
References: <20110323030326.789836913@google.com> <20110323030450.042414995@google.com>
 <1302010088.2225.1312.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 5 Apr 2011 19:25:38 -0700
Message-ID: <BANLkTi=P-qPfG+oxU_6oRjLV_qXpz1hYpQ@mail.gmail.com>
Subject: Re: [patch 14/15] sched: return unused quota on voluntary sleep
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
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

On Tue, Apr 5, 2011 at 6:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
>>
>> Signed-off-by: Paul Turner <pjt@google.com>
>> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>
> Shouldn't that be Suggested-by or somesuch? You wrote the patch, you
> send the patch, afaict it never passed through Bharata so where does
> that SOB come from?
>

This was previously iterated on off-list as the intent was always to
fix slack quota beyond the initial merge/review.
