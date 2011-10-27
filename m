Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1J0Pam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:30:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52712 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1J0Pak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:30:40 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MW0B4Ba_bo=yJF2MbYkkcDiAEDewnMrjDgCMKHRDnDDTg@mail.gmail.com>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
	<CAOJsxLH-O8+Fx=VLsoXhVLNtXWD_1eVrUMOgbk2DODbrwPAzhQ@mail.gmail.com>
	<20111027123713.GB22032@elte.hu>
	<4EA953E8.4020004@suse.cz>
	<CAOJsxLHT9V-K26=Qt10sDVibRjoVgZBVULsVwYD5oqrM0bN+5Q@mail.gmail.com>
	<CACqU3MW0B4Ba_bo=yJF2MbYkkcDiAEDewnMrjDgCMKHRDnDDTg@mail.gmail.com>
Date: Thu, 27 Oct 2011 18:30:40 +0300
X-Google-Sender-Auth: mln15B7H_7tkO8n4I3jVN2kxLVY
Message-ID: <CAOJsxLGFOtQrzbNMLCRTdsF6XSc9Gg76C5ag1gFh2g+3mvHxZQ@mail.gmail.com>
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Pekka Enberg <penberg@kernel.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 6:19 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> The use case is to be able to take a .config posted in a bug report
>> and easily turn that into something that the KVM tool can boot.
>>
>> "kvmconfig" really represents a virtualized x86 architecture
>> configuration.
>>
> How do you expect:
>
> # make ARCH=hexagon kvmconfig
>
> to behave ? If it is not meant to work outside the x86 world, it
> should not be accessible outside the x86 world.

Right. Hexagon is not interesting but ARM and PowerPC will be if
someone ports the KVM tool to the architectures.

>> Maybe the naming is off because it's not about
>> individual features like paeconfig or nfsconfig would be but rather
>> about turning on all the required options for virtualized x86 for the
>> KVM tool.
>>
>> If you have better ideas how to do this, we're happy to change the
>> implementation.
>>
> As I said, I'll have a look tonight to provide a better implementation.

Excellent, thanks!

                        Pekka
