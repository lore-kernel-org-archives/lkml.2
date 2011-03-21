Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1CUOPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:15:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:47300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1CUOPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:15:04 -0400
Date: Mon, 21 Mar 2011 07:09:27 -0700
From: Greg KH <gregkh@suse.de>
To: Olaf Hering <olaf@aepfle.de>
Cc: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hv: use sync_bitops when interacting with the hypervisor
Message-ID: <20110321140927.GA7358@suse.de>
References: <20110321134137.GA29305@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321134137.GA29305@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 02:41:37PM +0100, Olaf Hering wrote:
> Locking is required when tweaking bits located in a shared page, use the
> sync_ version of bitops. Without this change vmbus_on_event() will miss
> events and as a result, vmbus_isr() will not schedule the receive tasklet.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Great!  Can I get an Acked-by from Hank or Haiyang on this as well
before I apply it?

thanks,

greg k-h
