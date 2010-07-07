Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab0GGPSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:18:54 -0400
Received: from kroah.org ([198.145.64.141]:60693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0GGPSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:18:50 -0400
Date: Wed, 7 Jul 2010 08:14:19 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Scott Kidder <scott.kidder11@gmail.com>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 v4l-dvb tree
Message-ID: <20100707151419.GC2121@kroah.com>
References: <20100706175337.bec9305a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100706175337.bec9305a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 05:53:37PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/cx25821/cx25821-audups11.c between commit
> e302c8255a198a567dab3a4ace7bd0222a6dc037 ("V4L/DVB: cx25821: Removed
> duplicate code and cleaned up") from the v4l-dvb tree and commit
> 231ded903f2f30b2bcdbf6672c7197187e3bb1ee ("Staging: cx25821: added KERN_
> facility levels") from the staging-next tree.
> 
> The former moved all te code in this file into other files, so I
> effectively just dropped the usb patch by deleting this file.

That sounds correct to me, thanks for doing this.

greg k-h
