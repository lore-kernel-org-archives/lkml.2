Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0D1Ptb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:49:31 -0400
Received: from kroah.org ([198.145.64.141]:51437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0D1PtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:49:03 -0400
Date: Wed, 28 Apr 2010 08:26:54 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Jason Wong <tsanghan@gmail.com>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 pcmcia tree
Message-ID: <20100428152654.GE4483@kroah.com>
References: <20100428160741.2695a14f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428160741.2695a14f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:07:41PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/comedi/drivers/cb_das16_cs.c between commitc
> 8bf6e66c254bba7d0ea3f5d02420776dceac657 ("") from the pcmcia tree and
> commit 6ea17dd43c1153f99920e66f806d86f4e83583cc ("Staging: comedi:
> cb_das16_cs: fixed multiple brace coding style issues") from the
> staging-next tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks great, thanks,

greg k-h
