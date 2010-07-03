Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab0GCCAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:00:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab0GCCAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:00:17 -0400
Date: Fri, 2 Jul 2010 18:59:23 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] dmi-id: fix a memory leak in dmi_id_init error path
Message-ID: <20100703015923.GE16229@suse.de>
References: <1277951707.30073.5.camel@mola>
 <4C2D8FAD.7010704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2D8FAD.7010704@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 09:05:17AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 07/01/2010 04:35 AM, Axel Lin wrote:
> > This patch adds a missing kfree(dmi_dev) in dmi_id_init error path.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Greg, can you please route this through device tree?

I will do that, thanks.

greg k-h
