Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2GZXtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 19:49:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39905 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2GZXsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 19:48:54 -0400
Date: Thu, 26 Jul 2012 16:48:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com
Subject: Re: [vmw_vmci 01/11] Apply VMCI context code
Message-ID: <20120726234850.GB3849@kroah.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
 <1343345980-32397-2-git-send-email-astiegmann@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343345980-32397-2-git-send-email-astiegmann@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:39:30PM -0700, Andrew Stiegmann (stieg) wrote:
> Context code maintains state for vmci and allows the driver
> to communicate with multiple VMs.
> 
> Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>

One tiny nit:

> diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
> new file mode 100644
> index 0000000..46faf10
> --- /dev/null
> +++ b/drivers/misc/vmw_vmci/vmci_context.c
> @@ -0,0 +1,1269 @@
> +/*
> + * VMware VMCI Driver
> + *
> + * Copyright (C) 2012 VMware, Inc. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation version 2 and no later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

Are you prepared to track the office movements of the FSF for the next
40 years to keep this up to date?  If not, please don't include it, it's
not needed at all.

greg k-h
