Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1J0OLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:11:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39243 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1J0OLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:11:14 -0400
MIME-Version: 1.0
In-Reply-To: <4EA953E8.4020004@suse.cz>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
	<CAOJsxLH-O8+Fx=VLsoXhVLNtXWD_1eVrUMOgbk2DODbrwPAzhQ@mail.gmail.com>
	<20111027123713.GB22032@elte.hu>
	<4EA953E8.4020004@suse.cz>
Date: Thu, 27 Oct 2011 17:11:13 +0300
X-Google-Sender-Auth: VFzaW2gY3ek7b7VV-g67La9DPpM
Message-ID: <CAOJsxLHT9V-K26=Qt10sDVibRjoVgZBVULsVwYD5oqrM0bN+5Q@mail.gmail.com>
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Pekka Enberg <penberg@kernel.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 3:51 PM, Michal Marek <mmarek@suse.cz> wrote:
>> I like the feature - i hope it's expressed in the right Kbuild-ish
>> fashion.
>>
>> Acked-by: Ingo Molnar <mingo@elte.hu>
>
> I hope we won't now also be getting make nfsconfig, make paeconfig and
> whatnot :). Also, the lists of select statements might need updates from
> time to time, if new dependencies appear.

The use case is to be able to take a .config posted in a bug report
and easily turn that into something that the KVM tool can boot.

"kvmconfig" really represents a virtualized x86 architecture
configuration. Maybe the naming is off because it's not about
individual features like paeconfig or nfsconfig would be but rather
about turning on all the required options for virtualized x86 for the
KVM tool.

If you have better ideas how to do this, we're happy to change the
implementation.

                        Pekka
