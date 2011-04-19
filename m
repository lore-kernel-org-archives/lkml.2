Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1DSVTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:19:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30803 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab1DSVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e944xpwscmRWkeluBMhUHCqlwxaIMBV+Jz9+w7Yo2zxHDWGU6yajeuA0YbnneOSuEQ
         64tuF7pumxXuvdkNTIIQ==
MIME-Version: 1.0
In-Reply-To: <1303248056.2035.66.camel@laptop>
References: <BANLkTi=g6iPgdctAmuZ=bb8J6FqNJA-vZQ@mail.gmail.com>
	<1303240935.8345.7.camel@twins>
	<BANLkTi=GX3JGw-Dq+ejsCguV0A+9w2eCjQ@mail.gmail.com>
	<1303248056.2035.66.camel@laptop>
Date: Tue, 19 Apr 2011 21:19:04 +0000
Message-ID: <BANLkTim4BtB=qQW+x2O7D3eRH_bK6MC5-A@mail.gmail.com>
Subject: Re: [BUG] perf_event: sampling buffer format cannot handle
 multi-event sampling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 9:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-04-19 at 21:16 +0000, Stephane Eranian wrote:
>> > Or simply don't mix different sample_types in the same buffer?
>> >
>> Does the kernel disallow this when you merge the output via that
>> ioctl()?
>
> No, it will happily comply and provide you with hard to parse output.
> Just don't do that if you're not willing to untangle it ;-)
But even if you wanted, you could not, that was my point.

>
>
