Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab2KZSfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:35:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:55947 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab2KZSfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:35:44 -0500
Date: Mon, 26 Nov 2012 10:35:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sles 11 sp2 srp and multipath issues
Message-ID: <20121126183538.GA18590@kroah.com>
References: <CACaajQux0owmraiWmRbMLiO1oxFefP+PdiQKs1zgzrj7kcD=AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACaajQux0owmraiWmRbMLiO1oxFefP+PdiQKs1zgzrj7kcD=AA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 10:21:15PM +0400, Vasiliy Tolstov wrote:
> Hello, Greg. Hello kernel team!

Hey, 3rd time's a charm to get the email through :)

> I'm system enginer at clodo.ru
> (russian cloud hosting provider) we are use xen and sles11-sp2 for our
> compute xen nodes.
> Each virtual machine (domU) have disks that attached by Infiniband
> SRP. On top of disk that attached by srp we use multipath (to do
> failover)
> Now we have issues like all commands that uses multipath hang while
> one storage is rebooted.
> After some discussion with maintainer of linux-rdma (Bart Van Assche)
> and using it backported ib_srp with HA patches we can't solve deadlock
> issues. Bart thinks that SLES team does not backport some core scsi
> patches to their kernel (3.0.42) to prevent multipath deadlock
> (currently is about 2.5 minutes) on failed target.
> Is that possible to determine or getting help to solve this issue?

As you are using SLES, please contact the SUSE for support for that
kernel, as you are paying for it, and the community can't do anything to
support their kernel, sorry.

If you use a kernel.org released kernel, then we can help you out.

Best of luck,

greg k-h
