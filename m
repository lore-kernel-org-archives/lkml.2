Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1KHGbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:31:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1KHGbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:31:38 -0500
Date: Tue, 8 Nov 2011 08:32:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: virtio-pci new configuration proposal
Message-ID: <20111108063249.GB11577@redhat.com>
References: <20111104135113.GA24452@redhat.com>
 <1320414804.3334.13.camel@lappy>
 <20111104142338.GB24452@redhat.com>
 <1320418385.3334.25.camel@lappy>
 <20111106073007.GA7146@redhat.com>
 <1320611097.3299.10.camel@lappy>
 <20111106213849.GA14292@redhat.com>
 <871utktsuw.fsf@rustcorp.com.au>
 <20111107211413.GA11577@redhat.com>
 <87aa87sd4y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa87sd4y.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:23:33AM +1030, Rusty Russell wrote:
> Even so, should we just use the PCI cap list, and have each
> cap entry just contain a BIR & offset?
> 
> Thanks,
> Rusty.

And size :)
I say, Rusty, did you see my patch? That's what it's doing,
I also addressed the issue that with KVM on x86, PIO is faster
than MMIO so we need to use it for notifications/isr.

-- 
MST
