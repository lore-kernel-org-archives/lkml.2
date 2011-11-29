Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1K2PS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:18:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1K2PS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:18:27 -0500
Date: Tue, 29 Nov 2011 17:19:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
Message-ID: <20111129151958.GA31789@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com>
 <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 03:57:19PM +0200, Ohad Ben-Cohen wrote:
> > Is an extra branch faster or slower than reverting d57ed95?
> 
> Sorry, unfortunately I have no way to measure this, as I don't have
> any virtualization/x86 setup. I'm developing on ARM SoCs, where
> virtualization hardware is coming, but not here yet.

You can try using the micro-benchmark in tools/virtio/.
That does not need virtualization.

-- 
MST
