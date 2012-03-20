Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645Ab2CTPpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:45:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760585Ab2CTPp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:45:28 -0400
Date: Tue, 20 Mar 2012 17:45:17 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120320154517.GG27928@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F66E14F.3040809@cn.fujitsu.com>
 <4F6854F4.3060703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6854F4.3060703@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 05:59:16PM +0800, Wen Congyang wrote:
> At 03/19/2012 03:33 PM, Wen Congyang Wrote:
> > At 03/08/2012 03:57 PM, Wen Congyang Wrote:
> >> We can know the guest is paniced when the guest runs on xen.
> >> But we do not have such feature on kvm.
> >>
> >> Another purpose of this feature is: management app(for example:
> >> libvirt) can do auto dump when the guest is crashed. If management
> >> app does not do auto dump, the guest's user can do dump by hand if
> >> he sees the guest is paniced.
> >>
> >> I touch the hypervisor instead of using virtio-serial, because
> >> 1. it is simple
> >> 2. the virtio-serial is an optional device, and the guest may
> >>    not have such device.
> >>
> >> Changes from v2 to v3:
> >> 1. correct spelling
> >>
> >> Changes from v1 to v2:
> >> 1. split up host and guest-side changes
> >> 2. introduce new request flag to avoid changing return values.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > 
> > 
> > Hi all:
> > 
> > we neet this feature, but we don't decide how to implement it.
> > We have two solution:
> > 1. use vmcall
> > 2. use virtio-serial.
> > 
> > I will not change this patch set before we decide how to do it.
> > Can we make a decision recent days?
> 
> Anybody can decide which solution to use?
> 
To make an informed decision we need to have at least raw idea how
virtio-serial variant will look.

--
			Gleb.
