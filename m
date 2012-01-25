Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2AYNZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:25:10 -0500
Received: from bar.sig21.net ([80.81.252.164]:35987 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2AYNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:25:08 -0500
Date: Wed, 25 Jan 2012 14:25:03 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-3.2.1 + KVM: TSC unstable on Core i5-2400S / H67
Message-ID: <20120125132503.GA3399@sig21.net>
References: <20120124113608.GA16876@sig21.net>
 <20120125122702.GA30888@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125122702.GA30888@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 10:27:03AM -0200, Marcelo Tosatti wrote:
> On Tue, Jan 24, 2012 at 12:36:08PM +0100, Johannes Stezenbach wrote:
> > 
> > [23379.612251] usb 2-1.2: new high-speed USB device number 6 using ehci_hcd
> > [    0.006666] Marking TSC unstable due to KVM discovered backwards TSC
> > [23421.511167] Switching to clocksource hpet
...
> Can you please apply the following patch, and report back when it
> reproduces again.

I applied the patch and rebooted, I'll let you know
as soon as the issue reappears.

Thanks
Johannes
