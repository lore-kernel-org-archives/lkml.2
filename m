Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab1DNRel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:34:41 -0400
Received: from kroah.org ([198.145.64.141]:33151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab1DNRel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:34:41 -0400
Date: Thu, 14 Apr 2011 10:15:56 -0700
From: Greg KH <greg@kroah.com>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: linux-kernel@vger.kernel.org, Pavan Savoy <pavan_savoy@ti.com>
Subject: Re: [PATCH 0/3] shared transport robustness fixes
Message-ID: <20110414171556.GA10908@kroah.com>
References: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com>
 <BANLkTinyQ6kdCMG=gj1vXQifUNRA1Ewokg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinyQ6kdCMG=gj1vXQifUNRA1Ewokg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 05:54:40PM +0530, Pavan Savoy wrote:
> On Fri, Apr 8, 2011 at 3:27 PM,  <pavan_savoy@ti.com> wrote:
> > From: Pavan Savoy <pavan_savoy@ti.com>
> >
> > Texas Instruments' WiLink connectivity chipset's Bluetooth, FM and GPS
> > wireless technologies are interfaced over single UART, which is enabled
> > by the TI-ST line discipline driver.
> >
> > The following patches are updates and few fixes found during robustness testing
> > of the driver.
> > 1. The patch handles the delayed tty receive_buf function called by the TTY layer.
> > 2. Removes the dependency on rfkill for build from Kconfig
> > 3. Fix for the skipping the change remote baud rate command.
> 
> Greg,
> 
> Please review and queue up for merge, if its alright..

It's in my "to-apply" queue, still fighting through it all...

thanks,

greg k-h
