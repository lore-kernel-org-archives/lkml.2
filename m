Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0JEQKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:10:37 -0400
Received: from kroah.org ([198.145.64.141]:56010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab0JEQK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:10:27 -0400
Date: Tue, 5 Oct 2010 08:56:56 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Subject: Re: [PATCH 1/2] omap: add dsp platform device
Message-ID: <20101005155656.GA27130@kroah.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
 <1286208555-8829-2-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286208555-8829-2-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 07:09:14PM +0300, Felipe Contreras wrote:
> Otherwise tidspbridge cannot work.
> 
> It looks like this was dropped in the conversion to staging. I took the
> liberty of doing some cleaning up.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/mach-omap2/Makefile          |    4 ++
>  arch/arm/mach-omap2/dsp.c             |   85 +++++++++++++++++++++++++++++++++
>  arch/arm/plat-omap/common.c           |    2 +
>  arch/arm/plat-omap/devices.c          |   30 ++++++++++++
>  arch/arm/plat-omap/include/plat/dsp.h |   31 ++++++++++++

I need an ack from some omap maintainers before I can take this into the
staging tree.

thanks,

greg k-h
