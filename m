Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2ELPu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 11:50:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57730 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab2ELPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 11:50:57 -0400
Date: Sat, 12 May 2012 08:50:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com
Subject: Re: [PATCH v16 01/10]USB/ppc4xx: Add Synopsys DWC OTG Register
 definitions
Message-ID: <20120512155053.GB6023@kroah.com>
References: <201205031223.q43CN3LN022598@amcc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205031223.q43CN3LN022598@amcc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 05:53:03PM +0530, Rupjyoti Sarmah wrote:
> 
> Add Synopsys Design Ware core register definitions.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
> Signed-off-by: Tirumala R Marri <tmarri@apm.com>
> Signed-off-by: Fushen Chen <fchen@apm.com>
> Signed-off-by: Mark Miesfeld <mmiesfeld@apm.com>
> ---
>  drivers/usb/dwc/regs.h | 1326 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1326 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/dwc/regs.h

Why are you not cc: the linux-usb mailing list, and the proper
maintainers, for this patchset?

I'm guessing you aren't wanting to get these applied :)

greg k-h
