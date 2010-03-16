Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937572Ab0CPIXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:23:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43411 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936515Ab0CPIXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LdBwl/wzviQ4RNO44jWf4O8C3/PeRA1io727yi2gRx6uGrtOV76aJGKZRXJSjImWCX
         9zk6QKQCDuhKdsd4MwztDpGVWDuuvf7AUua3sE7W1A/+6k8OytnItTWJ7RuTyB7epk4y
         PLqQsYMCV1yh/nPpokp94OZRdeyqencZIEGJ0=
MIME-Version: 1.0
In-Reply-To: <4B9F39BE.40502@cs.helsinki.fi>
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>
	 <20100316061718.GA22651@elte.hu>
	 <84144f021003152358r41a79ccaxb18cf6368911266@mail.gmail.com>
	 <b6fcc0a1003160015j2926b2a2w4e7808939c4144d6@mail.gmail.com>
	 <4B9F39BE.40502@cs.helsinki.fi>
Date: Tue, 16 Mar 2010 10:23:19 +0200
Message-ID: <b6fcc0a1003160123k5876f092s9dab18862713c127@mail.gmail.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 9:56 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Alexey Dobriyan kirjoitti:
>>
>> On Tue, Mar 16, 2010 at 8:58 AM, Pekka Enberg <penberg@cs.helsinki.fi>
>> wrote:
>>>
>>> We should avoid creating tree-wide breakage for this kind of cleanups.
>>
>> This is done by compile testing, not by being smartass.
>
> I don't think compile testing is going to scale here because slab is used is
> so many places of the kernel.

Sigh.

If you want to skip compile testing, just say so in changelog.
