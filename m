Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2IJScZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:32:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42577 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab2IJScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:32:23 -0400
Date: Mon, 10 Sep 2012 11:29:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/20] Staging: ipack/bridges/tpci200: Put the TPCI200
 control registers into a struct.
Message-ID: <20120910182941.GA25400@kroah.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:51:39AM +0200, Samuel Iglesias Gonsálvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> This saves us from a little pointer arithmetic and cleans up the code a bit.
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/bridges/tpci200.c |   28 +++++++---------------------
>  drivers/staging/ipack/bridges/tpci200.h |   21 +++++++++++++--------
>  2 files changed, 20 insertions(+), 29 deletions(-)

This patch doesn't apply to my tree for some reason.

Also, all of your patches are in base64 mode, which makes it impossible
for me to fix them up by hand for issues like this.

Care to redo your series, and fix your email client, and resend them?

thanks,

greg k-h
