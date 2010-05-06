Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab0EFEUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 00:20:17 -0400
Received: from kroah.org ([198.145.64.141]:45286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab0EFEUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 00:20:14 -0400
Date: Wed, 5 May 2010 21:20:48 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>,
       Jiri Pirko <jpirko@redhat.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging-next tree with the net
	tree
Message-ID: <20100506042048.GA25425@kroah.com>
References: <20100506140543.d6f3841f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506140543.d6f3841f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 02:05:43PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/arlan/arlan-main.c between commit
> 22bedad3ce112d5ca1eaf043d4990fa2ed698c87 ("net: convert multicast list to
> list_head") from the net tree and commit
> dd730b627cf8ff0b9d20df94fd31b6192b188710 ("Staging: arlan: fixed
> unnecessary whitespace style issue in arlan-main.c") from the
> staging-next tree.
> 
> I fixed it up (see below - this is bigger than is would otherwise be
> because there is a conflict with another patch that was previously
> reported) and can carry the fix as necessary.

Thanks for doing this.  Hm, the arlan driver is scheduled to be deleted
in .35, so it would make things easier if I just do it now to keep these
kinds of merge issues from happening.  I'll queue that up tomorrow.

thanks,

greg k-h
