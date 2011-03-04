Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab1CDROi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:14:38 -0500
Received: from kroah.org ([198.145.64.141]:38602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759914Ab1CDROg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:14:36 -0500
Date: Fri, 4 Mar 2011 09:14:03 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, "Igor M. Liplianin" <liplianin@me.by>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20110304171403.GF22173@kroah.com>
References: <20110304163911.034f7f27.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304163911.034f7f27.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 04:39:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/Makefile between commit
> a1256092a1e87511c977a3d0ef96151cda77e5c9 ("[media] Altera FPGA firmware
> download module") from the v4l-dvb tree and commit
> 0867b42113ec4eb8646eb361b15cbcfb741ddf5b ("staging: gma500: Intel GMA500
> staging driver") from the staging tree.
> 
> One of the reasons I dislike unrelated white space changes ... I fixed it
> up (see below) and can carry the fix as necessary.

Looks good, thanks.

greg k-h
