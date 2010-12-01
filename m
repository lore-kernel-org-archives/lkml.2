Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0LABCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:02:32 -0500
Received: from kroah.org ([198.145.64.141]:59738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0LABCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:02:31 -0500
Date: Tue, 30 Nov 2010 16:53:32 -0800
From: Greg KH <greg@kroah.com>
To: David Sin <davidsin@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lajos Molnar <molnar@ti.com>
Subject: Re: [RFC v2 5/8] TILER-DMM: TILER interface file and documentation
Message-ID: <20101201005332.GA29171@kroah.com>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com>
 <1291147139-23472-6-git-send-email-davidsin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291147139-23472-6-git-send-email-davidsin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 01:58:56PM -0600, David Sin wrote:
> From: Lajos Molnar <molnar@ti.com>
> 
> This patch contains the TILER interface file and the documentation.
> 
> Signed-off-by: Lajos Molnar <molnar@ti.com>
> Signed-off-by: David Sin <davidsin@ti.com>
> ---
>  Documentation/arm/OMAP/TILER             |  126 ++++++++++++++++++++++
>  arch/arm/mach-omap2/include/mach/tiler.h |  173 ++++++++++++++++++++++++++++++

Shouldn't this .h file be in include/linux/ instead?  Why is it arch
specific?

thanks,

greg k-h
