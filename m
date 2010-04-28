Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0D1Ptd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:49:33 -0400
Received: from kroah.org ([198.145.64.141]:51432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab0D1PtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:49:03 -0400
Date: Wed, 28 Apr 2010 08:26:41 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wouter Van Rooy <wouter.vanrooy@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 v4l-dvb tree
Message-ID: <20100428152641.GD4483@kroah.com>
References: <20100428160749.52da847a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428160749.52da847a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:07:49PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/cx25821/cx25821-alsa.c between commit
> 4e0c923a0d23f86c7331b32bc2aeb280e10e029e ("V4L/DVB: Staging: cx25821: fix
> coding style issues in cx25821-alsa.c") from the v4l-dvb tree and commit
> 98a178beaaf4c9a0acc4815807be51425b91f0a7 ("Staging: cx25821 fixed C99
> comments, white spaces and unnecessary braces") from the staging-next
> tree.
> 
> I used the v4l-dvb versions of the conflicting bits (they looked neater
> to me).

Odd, Mauro, why are you applying coding style fixes to the staging tree
to your tree?  I'll be glad to take them instead.

thanks,

greg k-h
