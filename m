Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1GYH1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:27:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59275 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1GYH1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E2CC489.1090509@codemonkey.ws>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	<4E2CC489.1090509@codemonkey.ws>
Date: Mon, 25 Jul 2011 10:27:06 +0300
X-Google-Sender-Auth: _Axz_UaC8ktcPaha3xjNS0A-3B8
Message-ID: <CAOJsxLH-poY4-wEUPqAa8bzK+1WJ0UYtSuue72RYwcd_D0kx_A@mail.gmail.com>
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Mon, Jul 25, 2011 at 4:19 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> lguest already does this and lives in the kernel.

Does Lguest have SMP, usermode networking, and GUI support?

On Mon, Jul 25, 2011 at 4:19 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> So purely from a kernel perspective, why have two tools in the tree that do
> the same thing?  Shouldn't you at least unify the userspace with the lguest
> userspace?

Are you talking about Documentation/lguest/lguest.c? How would you
suggest we unify our code with that?

                                Pekka
