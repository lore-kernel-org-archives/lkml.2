Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1LAJHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:07:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1LAJHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:07:46 -0500
Date: Thu, 1 Dec 2011 11:09:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, dhowells@redhat.com,
        paulmck@linux.vnet.ibm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
Message-ID: <20111201090920.GA8231@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com>
 <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151958.GA31789@redhat.com>
 <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com>
 <20111130145004.GD21413@redhat.com>
 <CAK=WgbY59n9N_-2_TZ9wNBNcTMV1DCrz65e-Ae=xamcg6A0dOA@mail.gmail.com>
 <20111130231306.GD30031@redhat.com>
 <CAK=Wgbb5M62LgXY-sn7R6YautHxwqyDbPTeXYJxgmrS9fPXR9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=Wgbb5M62LgXY-sn7R6YautHxwqyDbPTeXYJxgmrS9fPXR9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 08:14:26AM +0200, Ohad Ben-Cohen wrote:
> On Thu, Dec 1, 2011 at 1:13 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > For x86, stores into memory are ordered. So I think that yes, smp_XXX
> > can be selected at compile time.
> 
> But then you can't use the same kernel image for both scenarios.

I was talking about virtio-pci. That always allocates the ring
in the normal memory.

> It won't take long until people will use virtio on ARM for both
> virtualization and for talking to devices, and having to rebuild the
> kernel for different use cases is nasty.

Yes, I understand that it's nasty.

> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
