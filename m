Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1LAGOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 01:14:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64647 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1LAGOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 01:14:47 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.53.1]
In-Reply-To: <20111130231306.GD30031@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151958.GA31789@redhat.com> <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com>
 <20111130145004.GD21413@redhat.com> <CAK=WgbY59n9N_-2_TZ9wNBNcTMV1DCrz65e-Ae=xamcg6A0dOA@mail.gmail.com>
 <20111130231306.GD30031@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 1 Dec 2011 08:14:26 +0200
Message-ID: <CAK=Wgbb5M62LgXY-sn7R6YautHxwqyDbPTeXYJxgmrS9fPXR9A@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 1:13 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> For x86, stores into memory are ordered. So I think that yes, smp_XXX
> can be selected at compile time.

But then you can't use the same kernel image for both scenarios.

It won't take long until people will use virtio on ARM for both
virtualization and for talking to devices, and having to rebuild the
kernel for different use cases is nasty.
