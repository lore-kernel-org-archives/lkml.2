Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1K1FQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:16:37 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34519 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab1K1FQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:16:34 -0500
X-Sasl-enc: 4yqn9piUdwipTsfQ7oNkhglwRTp68ydKQid4DdPPmycK 1322457393
Date: Mon, 28 Nov 2011 14:13:59 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: linux-next: manual merge of the staging tree with the
 driver-core tree
Message-ID: <20111128051359.GB9709@kroah.com>
References: <20111128152222.e6aeb95e31d45f44d8adf615@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128152222.e6aeb95e31d45f44d8adf615@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:22:22PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/iio/adc/ad799x_core.c between commit 6e5af184f810
> ("staging:iio: Use module_i2c_driver to register I2C drivers") from the
> tree and commit 55e4390cb04e ("staging:iio: Add missing
> MODULE_DEVICE_TABLE and MODULE_ALIAS") from the staging tree.
> 
> Just context differences.  I fixed it up (see below) and can carry the
> fix as necessary.

Looks great, thanks.

greg k-h
