Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0HTKaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:30:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61958 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0HTKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CybfDyDNK82vJdMD9G3ZJrqXvdKWla7BUruNLFMzHoQGGWTtUz3y+wcCqYIP5mYBqz
         eS/zUuwg1VLB8xqZ0yaIb+9TFPSq5NWHH0+bCMWxr/1CYHex9zIRnkRKjUNQ5wPfL84M
         wUSzRQjOsL1q5zzqnkwU0cwtzbxU+ffDbLlpk=
MIME-Version: 1.0
In-Reply-To: <1282298651.2605.769.camel@laptop>
References: <20100804184806.GL26154@erda.amd.com>
	<20100804192634.GG5130@lenovo>
	<20100806065203.GR26154@erda.amd.com>
	<20100806142131.GA1874@redhat.com>
	<20100809194829.GB26154@erda.amd.com>
	<20100817152225.GQ26154@erda.amd.com>
	<1282214753.1926.4669.camel@laptop>
	<20100819141240.GO4879@redhat.com>
	<1282228033.2605.204.camel@laptop>
	<20100820015017.GA4879@redhat.com>
	<20100820081605.GD17551@elte.hu>
	<1282298651.2605.769.camel@laptop>
Date: Fri, 20 Aug 2010 14:30:43 +0400
Message-ID: <AANLkTimfyi4G5TBb8owSQyCnSGqwB=pgU7Wxnmdj8_So@mail.gmail.com>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running perfctrs
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/10, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-08-20 at 10:16 +0200, Ingo Molnar wrote:
>>
>>
>> Please someone send the final version with a changelog, with all the acks
>> and
>> tested-by's added, so that i can send it Linuswards.
>
> I've got two patches queued, one from Robert (with a slight
> modification, which removes a goto) and one from myself converting the
> intel and p4 irq handler.
>
> They're available at:
>
>   programming.kicks-ass.net/sekrit/patches.tar.bz2
>
> I did add Tested-by tags, although I suspect its not the exact same bits
> Don tested..
>

My Ack if needed
