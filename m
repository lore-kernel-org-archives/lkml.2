Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408Ab2ESAf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:35:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222Ab2ESAfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:35:55 -0400
Date: Fri, 18 May 2012 17:35:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Staging: ipack: improve the register of a bus and a
 device in the bus.
Message-ID: <20120519003551.GB2206@kroah.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:10:05AM +0200, Samuel Iglesias Gonsalvez wrote:
> It adds and removes some fields in the struct ipack_device and
> ipack_bus_device to make it cleaner.
> 
> The API has change to group all the operations on these structures inside
> of the ipack driver.
> 
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/bridges/tpci200.c |   63 +++++++--------------------
>  drivers/staging/ipack/bridges/tpci200.h |    2 +-
>  drivers/staging/ipack/devices/ipoctal.c |   55 ++++++++++++++----------
>  drivers/staging/ipack/ipack.c           |   57 +++++++++++++++++++------
>  drivers/staging/ipack/ipack.h           |   71 +++++++++++++++++--------------
>  5 files changed, 131 insertions(+), 117 deletions(-)

Much better, thanks for reworking this.  Hopefully it makes more sense
now.

greg k-h
