Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab0LMSgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:36:17 -0500
Received: from kroah.org ([198.145.64.141]:43039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585Ab0LMSgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:36:08 -0500
Date: Mon, 13 Dec 2010 10:30:32 -0800
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2] Staging: rt2860: include KERN_* in printk
Message-ID: <20101213183032.GA6147@kroah.com>
References: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
 <1292198324-12072-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292198324-12072-1-git-send-email-agimenez@sysvalve.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:58:44AM +0100, L. Alberto Giménez wrote:
> Fix checkpatch complains.
> 
> The change of the DBGPRINT_ERR macro causes the change on the callers.

What change?

> 
> Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> ---
>  drivers/staging/rt2860/chip/rtmp_phy.h      |   14 ++++++------
>  drivers/staging/rt2860/common/ba_action.c   |    6 ++--
>  drivers/staging/rt2860/common/cmm_data.c    |    2 +-
>  drivers/staging/rt2860/common/cmm_mac_pci.c |   10 ++++----
>  drivers/staging/rt2860/common/cmm_mac_usb.c |    2 +-
>  drivers/staging/rt2860/common/cmm_wpa.c     |   22 +++++++-----------
>  drivers/staging/rt2860/common/ee_efuse.c    |   15 +++++++++---
>  drivers/staging/rt2860/common/mlme.c        |   13 +++++------
>  drivers/staging/rt2860/common/rt_rf.c       |    3 +-
>  drivers/staging/rt2860/common/rtmp_init.c   |   24 ++++++++-----------
>  drivers/staging/rt2860/common/rtmp_mcu.c    |    4 +-
>  drivers/staging/rt2860/common/spectrum.c    |    2 +-
>  drivers/staging/rt2860/pci_main_dev.c       |    2 +-
>  drivers/staging/rt2860/rt_linux.c           |   21 ++++++++---------
>  drivers/staging/rt2860/rt_linux.h           |    6 +----
>  drivers/staging/rt2860/rt_main_dev.c        |    2 +-
>  drivers/staging/rt2860/rt_usb.c             |   32 +++++++++++++-------------
>  drivers/staging/rt2860/sta/assoc.c          |    2 +-
>  drivers/staging/rt2860/sta/auth.c           |    3 +-
>  drivers/staging/rt2860/sta/connect.c        |    3 +-
>  drivers/staging/rt2860/sta/rtmp_data.c      |    2 +-
>  drivers/staging/rt2860/sta/sync.c           |    6 ++--
>  drivers/staging/rt2860/usb_main_dev.c       |   12 +++++-----
>  23 files changed, 99 insertions(+), 109 deletions(-)

That's a lot of different changes all in one patch.  Care to break it up
into a few different patches so it makes more sense?

thanks,

greg k-h
