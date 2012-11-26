Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2KZS3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:29:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:55801 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2KZS3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:29:49 -0500
Date: Mon, 26 Nov 2012 10:29:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: your mail
Message-ID: <20121126182946.GA14043@kroah.com>
References: <CACaajQtCTW_PKA25q3-4o4XAV6sgZnyD+Skkw6mhUHpRBEgbjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACaajQtCTW_PKA25q3-4o4XAV6sgZnyD+Skkw6mhUHpRBEgbjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 10:14:44PM +0400, Vasiliy Tolstov wrote:
> Hello, Greg. Hello kernel team! I'm system enginer at clodo.ru (russian cloud
> hosting provider) we are use xen and sles11-sp2 for our compute xen nodes.
> Each virtual machine (domU) have disks that attached by Infiniband SRP. On top
> of disk that attached by srp we use multipath (to do failover)
> Now we have issues like all commands that uses multipath hang while one storage
> is rebooted.
> After some discussion with maintainer of linux-rdma (Bart Van Assche) and using
> it backported ib_srp with HA patches we can't solve deadlock issues. Bart
> thinks that SLES team does not backport some core scsi patches to their kernel
> (3.0.42) to prevent multipath deadlock (currently is about 2.5 minutes) on
> failed target.
> Is that possible to determine or getting help to solve this issue?

As you are using SLES, please contact the SUSE for support for that
kernel, as you are paying for it, and the community can't do anything to
support their kernel, sorry.

Best of luck,

greg k-h
