Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0ELTuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:50:24 -0400
Received: from kroah.org ([198.145.64.141]:33055 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab0ELTuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:50:15 -0400
Date: Wed, 12 May 2010 12:50:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 pcmcia tree
Message-ID: <20100512195005.GD31534@kroah.com>
References: <20100512160352.daa747f8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512160352.daa747f8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 04:03:52PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/wlags49_h2/wl_cs.c between commit
> c8df2d45846e374de8ff601b9ea0537becfe75ca ("pcmcia: re-work
> pcmcia_request_irq()") from the pcmcia tree and commit  ("") from the
> staging-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Heh, I just hacked that driver up to build properly, odds are it doesn't
run :)

But your fix looks fine, thanks for it.

greg k-h
