Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0JULpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:45:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab0JULpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QtqQC1hJ/VSjPFFvRSOFK/a6IH10K6mhctiv+zN7FYXtLOyHbMux6LHvKAavV/ljD+
         2DEnEuDwTv0/zV3yPKJg==
MIME-Version: 1.0
In-Reply-To: <1287660946.3488.105.camel@twins>
References: <20101019134256.087045503@chello.nl>
	<1287660946.3488.105.camel@twins>
Date: Thu, 21 Oct 2010 13:45:41 +0200
Message-ID: <AANLkTimWd680ARZ=RUGC9qXpgzLE2fpr2NuQiCPbAHzH@mail.gmail.com>
Subject: Re: [PATCH 0/7] perf,x86: PEBS/BTS buffer allocation changes
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 1:35 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2010-10-19 at 15:42 +0200, Peter Zijlstra wrote:
>> Hi Stephane,
>>
>> Your PEBS/BTS buffer patch failed a .config dependent build, which on its own
>> was rather easy to fix, but Ingo objected to the size of the patch and asked me
>> to rewrite in smaller increments. This patch series is the result.
>>
>> What do you think?
>
> Stephane, can I get an ack/review tag for this?
>
At first glance, it looks okay, I will take a closer look this afternoon
and get back to you.
