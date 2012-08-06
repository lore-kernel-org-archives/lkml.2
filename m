Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab2HFVoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:44:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab2HFVoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:44:03 -0400
Date: Mon, 6 Aug 2012 14:43:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 2/2] input: misc: New USB eBeam input driver.
Message-ID: <20120806214359.GB30355@kroah.com>
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
 <1344288104-20731-3-git-send-email-yann.cantin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344288104-20731-3-git-send-email-yann.cantin@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:21:44PM +0200, Yann Cantin wrote:
> 
> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
> ---
>  drivers/input/misc/ebeam.c |  764 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 764 insertions(+)
>  create mode 100644 drivers/input/misc/ebeam.c

What adds this file to the build?

greg k-h
