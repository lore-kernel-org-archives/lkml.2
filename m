Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1CQWyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:54:41 -0400
Received: from kroah.org ([198.145.64.141]:36606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab1CQWya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:54:30 -0400
Date: Thu, 17 Mar 2011 15:54:15 -0700
From: Greg KH <greg@kroah.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        security@kernel.org, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] sound/pci/asihpi: check adapter index in
 hpi_ioctl
Message-ID: <20110317225415.GC31581@kroah.com>
References: <1300401144.1796.4.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300401144.1796.4.camel@dan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 06:32:24PM -0400, Dan Rosenberg wrote:
> The user-supplied index into the adapters array needs to be checked, or
> an out-of-bounds kernel pointer could be accessed and used, leading to
> potentially exploitable memory corruption.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> ---
>  sound/pci/asihpi/hpioctl.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

thanks,

greg k-h
