Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0JZEFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 00:05:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:43757 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0JZEFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 00:05:49 -0400
Date: Mon, 25 Oct 2010 21:06:19 -0700
From: Greg KH <gregkh@suse.de>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: felipe.contreras@nokia.com, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] staging: tidspbridge - misc fixes
Message-ID: <20101026040619.GA8549@suse.de>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288054306-4361-1-git-send-email-x0095840@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 07:51:38PM -0500, Fernando Guzman Lugo wrote:
> This set of patches fix some issues found in lastest tree.
> 
> Fernando Guzman Lugo (8):
>   staging: tidspbridge - remove req_addr from proc_map
>   staging: tidspbridge - add kconfig parameter for DMM size
>   staging: tidspbridge - change mmufault tasklet to a workqueue
>   staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
>   staging: tidspbridge - use GTP7 for DSP stack dump
>   staging: tidspbridge - remove disabling twl when printing DSP stack
>   staging: tidspbridge - fix some issues after iommu patches
>   staging: tidspbridge - make sync_wait_on_event interruptible

Are any of these really applicable for .37 after .37-rc1?  Or can they
wait for .38?

thanks,

greg k-h
