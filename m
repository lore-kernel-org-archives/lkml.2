Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1CNLi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:38:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42493 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1CNLi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=NI+JsMh7HRvblDh14GxuBC8yQUbrt+91+EuqwI53q1eruG8KnG2I901Jddh45Vo9QY
         nj/jKcsBNs6erjO8c9oCEf49zQGNMUuv5A0iIaFkzwxD0YiDMRa3+OaFrM66+vxqE2js
         M9+Bto5kx0xNMNR4DEdoITcsx4Bl+VTCTX0Vo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D7E095802000078000363D5@vpn.id2.novell.com>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
	<4D7E095802000078000363D5@vpn.id2.novell.com>
Date: Mon, 14 Mar 2011 12:38:55 +0100
Message-ID: <AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: amodra@gmail.com, Ingo Molnar <mingo@elte.hu>,
        "H.J. Lu" <hjl.tools@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Changing Alan's Email to valid <amodra@gmail.com> in CC ]

On Mon, Mar 14, 2011 at 12:26 PM, Jan Beulich <JBeulich@novell.com> wrote:
>>>> On 14.03.11 at 12:02, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
[...]
>> [2] Where can someone set a "global behaviour" (hardcoded options) for
>> his/her assembler in the kernel's build-system (speaking of
>> "--size-check=[error|warning]")?
>
> Nowhere, selecting behavior is possible only via the command line.
>

Via command-line, something like this would do it?

     $ export AS="/usr/bin/as --size-check=warning
[...]

- Sedat -
