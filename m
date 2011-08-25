Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1HYQcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:32:41 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54176 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab1HYQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:32:39 -0400
X-Sasl-enc: rmljk8QZNrzHswBOYbmNO2U7nL90Meu2HmaBbeMZj/JY 1314289958
Date: Thu, 25 Aug 2011 09:32:34 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] tty/powerpc: fix build break with ehv_bytechan.c on
 allyesconfig
Message-ID: <20110825163234.GA31629@kroah.com>
References: <1314289245-14946-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314289245-14946-1-git-send-email-timur@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 11:20:45AM -0500, Timur Tabi wrote:
> The Kconfig for the ePAPR hypervisor byte channel driver has a "depends on PPC",
> which means it would compile on all PowerPC platforms, even though it's
> only been tested on Freescale platforms.  Change the Kconfig to depend on
> FSL_SOC instead.

tested doesn't mean that it shouldn't still build properly for other
platforms, right?

What is keeping the driver from building on all PPC, or even all arches
today?

greg k-h
