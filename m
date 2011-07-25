Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab1GYIR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:17:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64985 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1GYIRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110725081102.GA3895@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CC489.1090509@codemonkey.ws>
	<CAOJsxLH-poY4-wEUPqAa8bzK+1WJ0UYtSuue72RYwcd_D0kx_A@mail.gmail.com>
	<4E2D1D07.9020009@redhat.com>
	<CAFO3S428qqUAu19QjPxDDAVv+eJSX0MEfYp5y03znNi6XbEtTg@mail.gmail.com>
	<20110725081102.GA3895@elte.hu>
Date: Mon, 25 Jul 2011 11:17:50 +0300
X-Google-Sender-Auth: OtndEyWN_VoRJjzJXmpEW1Cik3Q
Message-ID: <CAOJsxLGctVibGRkCFX+ok-OqTyCeSpuKzQ+1ojHOpTKYLO97Zg@mail.gmail.com>
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Asias He <asias.hejun@gmail.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        prasadjoshi124@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 4:19 AM, Anthony Liguori<anthony@codemonkey.ws> wrote:
>> >> >  lguest already does this and lives in the kernel.

On 07/25/2011 10:27 AM, Pekka Enberg wrote:
>> >> Does Lguest have SMP, usermode networking, and GUI support?

On Mon, Jul 25, 2011 at 3:36 PM, Avi Kivity <avi@redhat.com> wrote:
>> > IIRC, yes, no, and no.

* Asias He <asias.hejun@gmail.com> wrote:
>> And Lguest only supports 32-bit kernel.

On Mon, Jul 25, 2011 at 11:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
> The answer to SMP is 'no' as well, as lguest supports only a single
> CPU:
>
>   [Documentation/virtual/lguest/lguest.c]
>
>        /* We're CPU 0.  In fact, that's the only CPU possible right now. */
>        cpu_id = 0;

Uhm - so why bring up Lguest at all in this pull request? Anthony,
what am I missing here?

                        Pekka
