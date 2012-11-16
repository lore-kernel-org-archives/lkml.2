Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2KPRoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:44:16 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2KPRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:44:14 -0500
Date: Fri, 16 Nov 2012 09:44:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, jens.taprogge@taprogge.org,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH] ipack: move header files to include/linux
Message-ID: <20121116174410.GA2143@kroah.com>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:34:36PM +0100, Samuel Iglesias Gonsalvez wrote:
> Move ipack header files to include/linux/ directory where they belong to.
> 
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/ipack/carriers/tpci200.h |    3 +-
>  drivers/ipack/devices/ipoctal.c  |    2 +-
>  drivers/ipack/ipack.c            |    2 +-
>  drivers/ipack/ipack.h            |  215 --------------------------------------
>  drivers/ipack/ipack_ids.h        |   32 ------
>  include/linux/ipack.h            |  214 +++++++++++++++++++++++++++++++++++++
>  include/linux/ipack_ids.h        |   32 ++++++
>  7 files changed, 249 insertions(+), 251 deletions(-)
>  delete mode 100644 drivers/ipack/ipack.h
>  delete mode 100644 drivers/ipack/ipack_ids.h
>  create mode 100644 include/linux/ipack.h
>  create mode 100644 include/linux/ipack_ids.h

Can you send me a patch in -M format, that just shows the files moving
next time?

Also, do we really need the ipack_ids.h file in include/linux?  It looks
like only the core ipack code cares about the values there, right?

thanks,

greg k-h
