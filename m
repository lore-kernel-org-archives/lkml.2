Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab2EOXrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:47:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63542 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147Ab2EOXrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:47:48 -0400
Date: Tue, 15 May 2012 16:47:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, acking@vmware.com, dtor@vmware.com,
        dsouders@vmware.com, cschamp@vmware.com, akpm@linux-foundation.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [vmw_vmci RFC 01/11] Apply VMCI context code
Message-ID: <20120515234743.GA1758@kroah.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
 <1337094428-20453-2-git-send-email-astiegmann@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337094428-20453-2-git-send-email-astiegmann@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 08:06:58AM -0700, Andrew Stiegmann (stieg) wrote:
> +/*
> + *----------------------------------------------------------------------
> + *
> + * ctx_signal_notify --
> + *
> + *      Sets the notify flag to true.  Assumes that the context lock is
> + *      held.
> + *
> + * Results:
> + *      None.
> + *
> + * Side effects:
> + *      None.
> + *
> + *----------------------------------------------------------------------
> + */
> +
> +static void ctx_signal_notify(struct vmci_ctx *context)
> +{
> +	if (context->notify)
> +		*context->notify = true;
> +}

What's with the bizarre comment block format here and throughout the
code?  Care to fix it up (i.e. delete it all from static functions, and
use kerneldoc for public functions.)

thanks,

greg k-h
