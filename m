Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1HKWCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 18:02:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1HKWCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 18:02:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ALL35QqCXggHswc7V6Gv9ZDmCxnat8xbdcFX6qC84dkIdmMG9WMptNjN0nUXOstjN
	w/Nb7IAyr0yhRzcmGbJgA==
MIME-Version: 1.0
In-Reply-To: <1313097475.26866.18.camel@twins>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	<1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	<1313091323.8491.30.camel@twins>
	<CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
	<1313094223.26866.15.camel@twins>
	<CAAuSN90CXXEdco_fNYrv-ZUZPr4nB4HYPM1NCgaSgGz+Z-jaRQ@mail.gmail.com>
	<1313097475.26866.18.camel@twins>
Date: Thu, 11 Aug 2011 15:02:32 -0700
X-Google-Sender-Auth: WUyxhDN2DSX7yXNph-ZodO8lcMg
Message-ID: <CAAuSN916+7=Z-eFGRVMUydni=ougtFX_uvy6LXSUCPR0RtkcJQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Alex Neronskiy <zakmagnus@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 2:17 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-08-11 at 13:31 -0700, Alex Neronskiy wrote:
>>
>> > I mean, we're at the point where a PREEMPT=y kernel has a pretty decent
>> > latency and the PREEMPT_RT kernels live at ~30us. So wth are you
>> > measuring?
>> Well, not all kernels have PREEMPT. Chromebook kernels don't, for example.
>
> Can one infer from that statement that the purpose is trying to measure
> non preempt latency? Why not use the tracer build for that purpose?
>
> Still the watchdog ticks at 1s intervals or so, anything that takes that
> long, even on voluntary preemption kernels is quite insane.
I think Don grasped the sentiment well about a month ago when he
commented on the first version of the patch, so I'll just resend his
words:
On Wed, Jul 13, 2011 at 6:43 AM, Don Zickus <dzickus@redhat.com> wrote:
> I like the idea of this patch.  It definitely helps with better statistics
> when trying to set the appropriate values for a soft/hard lockup as
> opposed to pulling numbers from the air.
