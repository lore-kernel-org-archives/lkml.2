Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2KFJK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:10:26 -0500
Received: from mail.vyatta.com ([76.74.103.46]:33209 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2KFJKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:10:23 -0500
Date: Tue, 6 Nov 2012 10:10:13 +0100
From: Stephen Hemminger <shemminger@vyatta.com>
To: George Zhang <georgezhang@vmware.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, davem@davemloft.net,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/6] VSOCK: vsock protocol implementation.
Message-ID: <20121106101013.09806f81@s6510.linuxnetplumber.net>
In-Reply-To: <20121105180043.21472.95003.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121105175730.21472.99155.stgit@promb-2n-dhcp175.eng.vmware.com>
	<20121105180043.21472.95003.stgit@promb-2n-dhcp175.eng.vmware.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012 10:00:51 -0800
George Zhang <georgezhang@vmware.com> wrote:

> +	/* Added in 2.6.10. */
> +	.owner = THIS_MODULE,

Thanks for submitting this, it will make life easier for distro's
that now have to go through extra effort to include out of mainline
support for Vmware.

You did some scrubbing of the macro's to support multiple kernel
versions, but there are still some leftovers.
This code seems to have a lot of "this added in version xxx"
type comments. These are probably not a good idea to include
in the mainline kernel code. 
