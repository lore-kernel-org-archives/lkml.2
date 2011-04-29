Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666Ab1D2Rh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:37:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63229 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412Ab1D2RhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CY+4k677dSZd5d4hP2jFZhulU7kbvhaSmNhS7DTp+hR7Hp4i/K53NGzZV5oj85T/Bm
         lbJnLA5hl48ray91FmWv1ZpFFUFEtpfHO+JMSq2wz09noGR5MO5EqowoPsUfb4F887L6
         l0JlPUMPq8xHBfFmxtQ/pThav6HgNiLDDjOIo=
MIME-Version: 1.0
In-Reply-To: <20110429172525.GA2745@tassilo.jf.intel.com>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
	<BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
	<20110429172525.GA2745@tassilo.jf.intel.com>
Date: Fri, 29 Apr 2011 20:37:23 +0300
X-Google-Sender-Auth: NiRnYv5Cxv1V7XpQL8VWZxAUTss
Message-ID: <BANLkTim3bojtfeeWsAFx2Gct7LsvGCdn-w@mail.gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
From: Pekka Enberg <penberg@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 8:25 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> >  2.  Users are too stupid to use the raw functionality properly;
>> >      we should only allow a kernel-developer-approved small subset
>> >      of the features provided by the CPU as described in the intel
>> >      developers manuals.
>> >
>> > #2 seems like a gross misinterpretation of the whole "Linux gives you
>> > enough rope to shoot yourself in the foot" policy from days passed, but
>> > maybe things have moved on.
>>
>> That's a gross misrepresentation of what Ingo has been saying on LKML.
>> Really, learn to work with relevant maintainers before you ask Linus
>> to revert something.
>
> Ingo may not have explicitely said (2), but at least his revert (disabling
> the raw interface users are asking for) is practically implementing (2).
>
> Actions speak louder than words.
>
> That is either you have a raw interface or you only have the cooked
> interface or you have both. Since he reverted raw only cooked
> is left, which is (2)
>
> I agree with Vince it's a bad policy.

So a maintainer reverts an ABI that he thinks needs more thought/work
before it's too late and we're stuck with it forever. Can you please
explain what's the problem here?

Asking Linus to revert the commit is short-sighted and doesn't solve
the problem. Learn to work with the maintainer and save yourself a lot
of trouble.
