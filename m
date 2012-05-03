Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab2ECXcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:32:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2ECXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:32:42 -0400
Date: Thu, 3 May 2012 16:32:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Davidson <md@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: fix DEVICE_INT_ATTR to use correct
 show/store functions
Message-ID: <20120503233239.GB9582@kroah.com>
References: <20120503231903.02D1D8095E@fiasco.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503231903.02D1D8095E@fiasco.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 04:19:02PM -0700, Michael Davidson wrote:
> [PATCH] driver-core: fix DEVICE_INT_ATTR to use correct show/store functions

This line isn't needed again in the patch body like this :(

> DEVICE_INT_ATTR() should use device_show_int() and device_store_int()
> not device_show_ulong() and device_store_ulong()
> 
> Signed-off-by: Michael Davidson <md@google.com>

Is this something that fixes a problem you have seen, so it needs to go
in now, and backported to stable kernel releases, or can it wait for 3.5
and you found it just by looking at the code?

thanks,

greg k-h
