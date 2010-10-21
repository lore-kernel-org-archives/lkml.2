Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0JUOam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:30:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12141 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0JUOal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Bm1Nrudh5A3NcDPvPjrpTR9QzzaV9MTKXca3stnLLQ/iZgY6fzS7FDYUVMCpZQisOY
         IfUOFGdHiLfXbdBSxYvw==
MIME-Version: 1.0
In-Reply-To: <1287660946.3488.105.camel@twins>
References: <20101019134256.087045503@chello.nl>
	<1287660946.3488.105.camel@twins>
Date: Thu, 21 Oct 2010 16:30:30 +0200
Message-ID: <AANLkTinR1KiiTyR3zbOWXUcqXjdXFuv_tq21SXvWc2-X@mail.gmail.com>
Subject: Re: [PATCH 0/7] perf,x86: PEBS/BTS buffer allocation changes
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works ok for me.

Acked-by: Stephane Eranian <eranian@google.com>


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
>
