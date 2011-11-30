Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab1K3L4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:56:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63097 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab1K3L4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:56:15 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.19.40]
In-Reply-To: <20111129151958.GA31789@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151958.GA31789@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 30 Nov 2011 13:55:53 +0200
Message-ID: <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 5:19 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Tue, Nov 29, 2011 at 03:57:19PM +0200, Ohad Ben-Cohen wrote:
>> > Is an extra branch faster or slower than reverting d57ed95?
>>
>> Sorry, unfortunately I have no way to measure this, as I don't have
>> any virtualization/x86 setup. I'm developing on ARM SoCs, where
>> virtualization hardware is coming, but not here yet.
>
> You can try using the micro-benchmark in tools/virtio/.

Hmm, care to show me exactly what do you mean ?

Though I somewhat suspect that any micro-benchmarking I'll do with my
random ARM SoC will not have much value to real virtualization/x86
workloads.

Thanks,
Ohad.
