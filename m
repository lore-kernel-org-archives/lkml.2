Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0IHWnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:43:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab0IHWnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:43:32 -0400
Date: Wed, 8 Sep 2010 15:44:09 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Convert vmbus driver interface
	function pointer table to constant
Message-ID: <20100908224409.GB12200@suse.de>
References: <1FB5E1D5CA062146B38059374562DF72854C92E8@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF72854C92E8@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 08:29:45PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Convert vmbus driver interface function pointer table to constant
> The vmbus interface functions are assigned to a constant - vmbus_ops.

You also remove a function pointer in this patch, why?  Please break up
the patch into logical parts, one patch, one thing.

This looks like it should be 2 patches, right?

thanks,

greg k-h
