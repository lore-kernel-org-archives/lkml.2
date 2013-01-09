Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3AIAPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:15:44 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:34960 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3AIAPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:15:43 -0500
Date: Tue, 8 Jan 2013 16:15:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 07/12] VMCI: queue pairs implementation.
Message-ID: <20130109001539.GA24989@kroah.com>
References: <20130108234751.2698.66606.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20130108235444.2698.24076.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108235444.2698.24076.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:54:54PM -0800, George Zhang wrote:
> VMCI queue pairs allow for bi-directional ordered communication between host and guests.

You should wrap your commit lines at 72 characters, like git asks you to :)

> +/* Guest device port I/O. */
> +struct PPNSet {
> +	u64 num_produce_pages;
> +	u64 num_consume_pages;
> +	u32 *produce_ppns;
> +	u32 *consume_ppns;
> +	bool initialized;
> +};

I know this is a private structure to the driver, so it's not that big
of a deal at all, but the naming for this is a bit odd (mixed case.)

Not a show stopper at all, but if you had run checkpatch.pl on it, it
would have warned you about this.

thanks,

greg k-h
