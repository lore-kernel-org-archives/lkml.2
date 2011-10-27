Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1J0PT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:19:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1J0PT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHT9V-K26=Qt10sDVibRjoVgZBVULsVwYD5oqrM0bN+5Q@mail.gmail.com>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
	<CAOJsxLH-O8+Fx=VLsoXhVLNtXWD_1eVrUMOgbk2DODbrwPAzhQ@mail.gmail.com>
	<20111027123713.GB22032@elte.hu>
	<4EA953E8.4020004@suse.cz>
	<CAOJsxLHT9V-K26=Qt10sDVibRjoVgZBVULsVwYD5oqrM0bN+5Q@mail.gmail.com>
Date: Thu, 27 Oct 2011 11:19:26 -0400
Message-ID: <CACqU3MW0B4Ba_bo=yJF2MbYkkcDiAEDewnMrjDgCMKHRDnDDTg@mail.gmail.com>
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 27, 2011 at 10:11 AM, Pekka Enberg <penberg@kernel.org> wrote:
> On Thu, Oct 27, 2011 at 3:51 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> I like the feature - i hope it's expressed in the right Kbuild-ish
>>> fashion.
>>>
>>> Acked-by: Ingo Molnar <mingo@elte.hu>
>>
>> I hope we won't now also be getting make nfsconfig, make paeconfig and
>> whatnot :). Also, the lists of select statements might need updates from
>> time to time, if new dependencies appear.
>
> The use case is to be able to take a .config posted in a bug report
> and easily turn that into something that the KVM tool can boot.
>
> "kvmconfig" really represents a virtualized x86 architecture
> configuration.
>
How do you expect:

# make ARCH=hexagon kvmconfig

to behave ? If it is not meant to work outside the x86 world, it
should not be accessible outside the x86 world.

> Maybe the naming is off because it's not about
> individual features like paeconfig or nfsconfig would be but rather
> about turning on all the required options for virtualized x86 for the
> KVM tool.
>
> If you have better ideas how to do this, we're happy to change the
> implementation.
>
As I said, I'll have a look tonight to provide a better implementation.

 - Arnaud

>                        Pekka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
