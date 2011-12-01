Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1LAHPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:15:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63143 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1LAHPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:15:32 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.53.1]
In-Reply-To: <87zkfdrpn8.fsf@rustcorp.com.au>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151958.GA31789@redhat.com> <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com>
 <20111130145004.GD21413@redhat.com> <CAK=WgbY59n9N_-2_TZ9wNBNcTMV1DCrz65e-Ae=xamcg6A0dOA@mail.gmail.com>
 <20111130231306.GD30031@redhat.com> <87zkfdrpn8.fsf@rustcorp.com.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 1 Dec 2011 09:15:11 +0200
Message-ID: <CAK=Wgbb7kJu7WgJvCGb==7Oh_xCBrj6m2s1OH-WofXe7VgLBcA@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 4:28 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hmm, we got away with light barriers because we knew we were not
> *really* talking to a device.  But now with virtio-mmio, turns out we
> are :)
>
> I'm really tempted to revert d57ed95 for 3.2, and we can revisit this
> optimization later if it proves worthwhile.

+1
