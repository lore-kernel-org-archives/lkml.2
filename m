Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab2IDWLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:11:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55676 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772Ab2IDWLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:11:00 -0400
Date: Tue, 4 Sep 2012 15:10:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: "Alexis R. Cortes" <alexis.cortes@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, brian.quach@ti.com, jorge.llamas@ti.com
Subject: Re: usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP Hardware
Message-ID: <20120904221056.GA19653@kroah.com>
References: <501C1FCB.1050800@ti.com>
 <502A7949.3090500@ti.com>
 <003601cd8acc$ca4d7dd0$5ee87970$@cortes@ti.com>
 <20120904214937.GD16847@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904214937.GD16847@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:49:37PM -0700, Sarah Sharp wrote:
> Hi Alexis,
> 
> You caught me just before I left for vacation, which is why nothing has
> been done with this patch.  I think it's fine, and I'll try to apply it
> to my tree and send it to Greg tomorrow.
> 
> It is a larger patch, but it fixes a bug that's pretty user visible
> (dead USB ports), so my inclination is to queue it for stable as well.
> Greg, any objections?

None from me, it needs to get into older kernels as well.

thanks,

greg k-h
