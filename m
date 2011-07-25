Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1GYHjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:39:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50294 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1GYHjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <4E2D1D07.9020009@redhat.com>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CC489.1090509@codemonkey.ws>
	<CAOJsxLH-poY4-wEUPqAa8bzK+1WJ0UYtSuue72RYwcd_D0kx_A@mail.gmail.com>
	<4E2D1D07.9020009@redhat.com>
Date: Mon, 25 Jul 2011 10:39:45 +0300
X-Google-Sender-Auth: O6SJ8L81Bg6iCAyFhon7ONB-Now
Message-ID: <CAOJsxLHgtmv2muHTUqyXv_4a0Pt27vgR1D-UtwBz6n7yUa6--w@mail.gmail.com>
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, torvalds@linux-foundation.org,
        mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Mon, Jul 25, 2011 at 10:36 AM, Avi Kivity <avi@redhat.com> wrote:
>> Are you talking about Documentation/lguest/lguest.c? How would you
>> suggest we unify our code with that?
>
> It should be easy to have tools/kvm drive lguest - they're both virtio
> based.  All you need to do is provide yet another ops structure to drive the
> two ABIs.

Right, we could do that. But for what purpose? I thought Lguest ABI
was mostly for educational and testing purposes.

On Mon, Jul 25, 2011 at 10:36 AM, Avi Kivity <avi@redhat.com> wrote:
> I guess lguest.c has to remain, as point of lguest was a simple teaching aid
> for virtualization (which doesn't work very well, as the techniques it uses
> are obsolete).

Yup, I don't see point in merging lguest.c with tools/kvm.

                        Pekka
