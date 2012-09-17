Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2IQLU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:20:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51141 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755874Ab2IQLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:20:23 -0400
X-Sasl-enc: FzZn4or0gjnQO/RKOx3pWaZg/KseP0rlSIx+7obya+lb 1347880822
Date: Mon, 17 Sep 2012 04:20:21 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: Re: linux-next: manual merge of the staging tree with the tty tree
Message-ID: <20120917112021.GB28478@kroah.com>
References: <20120917173706.44575edebd95adaebe557b67@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917173706.44575edebd95adaebe557b67@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 05:37:06PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/ipack/devices/ipoctal.c between commit 734cc1783816
> ("TTY: use tty_port_register_device") from the tty tree and commit
> d04600679ba0 ("Staging: ipack/devices/ipoctal: simplify ipoctal_write_tty
> ()") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks for this.

greg k-h
