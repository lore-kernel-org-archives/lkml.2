Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0DBQxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:53:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab0DBQxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:53:15 -0400
Date: Fri, 2 Apr 2010 09:53:24 -0700
From: Greg KH <gregkh@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devmem: Handle class_create() failure
Message-ID: <20100402165324.GD32081@suse.de>
References: <20100402072920.GH5594@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402072920.GH5594@kryten>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 06:29:20PM +1100, Anton Blanchard wrote:
> 
> I hit this when we had a bug in IDR for a few days. Basically sysfs would
> fail to create new inodes since it uses an IDR and therefore class_create would
> fail.
> 
> While we are unlikely to see this fail we may as well handle it instead of
> oopsing.

Is this something that we need for .34?  How were you getting this to
fail in the first place?

thanks,

greg k-h
