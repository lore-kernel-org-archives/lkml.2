Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab1CDROk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:14:40 -0500
Received: from kroah.org ([198.145.64.141]:38597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970Ab1CDROf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:14:35 -0500
Date: Fri, 4 Mar 2011 09:13:43 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, "Igor M. Liplianin" <liplianin@me.by>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20110304171343.GE22173@kroah.com>
References: <20110304163905.ed6dd630.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304163905.ed6dd630.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 04:39:05PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/Kconfig between commit
> a1256092a1e87511c977a3d0ef96151cda77e5c9 ("[media] Altera FPGA firmware
> download module") from the v4l-dvb tree and commit
> 0867b42113ec4eb8646eb361b15cbcfb741ddf5b ("staging: gma500: Intel GMA500
> staging driver") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

That looks correct.

Mauro, what is this driver and why is it added to the staging tree?

curious,

greg k-h
