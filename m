Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0JUOfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:35:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0JUOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DjqPE1xVWIH30x2QuLE8+U11ripCgqlPc9SzlWGXFg2C71SsLR29l5YNPlMeySDl2a
         nKEGCAMf234pKdWb5mUA==
MIME-Version: 1.0
In-Reply-To: <1287671649.3488.128.camel@twins>
References: <20101019134256.087045503@chello.nl>
	<1287660946.3488.105.camel@twins>
	<AANLkTinR1KiiTyR3zbOWXUcqXjdXFuv_tq21SXvWc2-X@mail.gmail.com>
	<1287671649.3488.128.camel@twins>
Date: Thu, 21 Oct 2010 16:35:41 +0200
Message-ID: <AANLkTimVvehCxRsMMOtpU5q8EwvdZf4A91_-5h9yOwd-@mail.gmail.com>
Subject: Re: [PATCH 0/7] perf,x86: PEBS/BTS buffer allocation changes
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 4:34 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-10-21 at 16:30 +0200, Stephane Eranian wrote:
>> Works ok for me.
>
> Thanks! Will send this and your two group time accounting patches to
> Ingo later today.
>
Ok, once you do that, I will post a 2nd version of my patch to get
time_enabled, time_running working in samples. I got the shadow
approach to work. But I need the reverted event_sched_in() first.
