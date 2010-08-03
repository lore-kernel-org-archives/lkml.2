Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0HCRrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:47:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:44260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab0HCRrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:47:47 -0400
Date: Tue, 3 Aug 2010 10:42:43 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 4/6] staging: hv: Removed TODO for VMBUS, it mirrors
 HYPER-V behavior to closely
Message-ID: <20100803174243.GE1455@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D2F@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FD1D2F@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:31:54PM +0000, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Removed TODO for VMBUS, it mirrors HYPER-V behaviour to closely and does not really share any 
> usable functionality of the Linux kernel facilities. There is not really an easy way to combine functionality.

Are you sure about that?  Right now, the code doesn't look like any
other virtual bus code, but that's because it needs to be fixed up and
work properly (not with the two layers of indirection that was added a
long time ago before the code was opened up.)

I think once the code is cleaned up properly, you might find that it can
be combined much easier than you think...

So no, I'll not allow this TODO item to be removed until after the vbus
code is fixed up, and you can convince me that it really is unique
enough to remain as-is.

Oh, and again, please properly line-wrap your changelog comments.

thanks,

greg k-h
