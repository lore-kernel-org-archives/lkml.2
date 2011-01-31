Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1AaSsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:48:55 -0500
Received: from kroah.org ([198.145.64.141]:54115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab1AaSsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:48:53 -0500
Date: Mon, 31 Jan 2011 10:47:26 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20110131184726.GB17755@kroah.com>
References: <20110131161640.93d8688a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131161640.93d8688a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:16:40PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c between commit
> f32b8453e5a5587ae112ba478ae0bbad74e83d22 ("Staging: ste_rmi4: use after
> input_unregister_device()") from the staging.current tree and commit
> dc7b202a4ee6cb686e2bbef80c84443f43ec91bd ("staging/ste_rmi4: Remove
> obsolete cleanup for clientdata") from the staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Thanks, that looks correct to me.  I'll apply this when Linus syncs up
with my staging-linus tree.

greg k-h
