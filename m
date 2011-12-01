Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1LAGVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 01:21:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47246 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1LAGVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 01:21:20 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.53.1]
In-Reply-To: <20111130234318.GC31069@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com> <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
 <20111130145958.GE21413@redhat.com> <CAK=WgbYyFdLftE_kp2_JOThVhn-FzGsDqVqKn0Jwm2teQyZBNA@mail.gmail.com>
 <20111130161555.GB25812@redhat.com> <CAK=WgbazBq4GVo16sZsrZirgMYbwMcWtPaqn90c6d9Phr0gh3A@mail.gmail.com>
 <CAK=WgbbZH3ZFzbwwyVBGEvwHPbogDW6+Kb_1pRam2jj5oJHuDA@mail.gmail.com> <20111130234318.GC31069@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 1 Dec 2011 08:20:59 +0200
Message-ID: <CAK=WgbYysMUQjWmgZhHBQJxcyG_J8H-f8FzZwSOVuTRjPRAiUQ@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 1:43 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> And these accesses need to be ordered with DSB? Or DMB?

DMB (i.e. smp barriers) should be enough within Normal memory
accesses, though the other issues that were reported to me are a bit
concerning. I'm still trying to get more information about them, in
the hopes that I can eventually reproduce them myself.
