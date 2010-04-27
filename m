Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0D0POx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:14:53 -0400
Received: from kroah.org ([198.145.64.141]:44779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0D0POt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:14:49 -0400
Date: Tue, 27 Apr 2010 08:13:35 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Pirko <jpirko@redhat.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, John Sheehan <john.d.sheehan@gmail.com>
Subject: Re: linux-next: manual merge of the staging-next tree with the net
 tree
Message-ID: <20100427151335.GB7653@kroah.com>
References: <20100427142655.49673ff1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427142655.49673ff1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 02:26:55PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/arlan/arlan-main.c between commit
> 22bedad3ce112d5ca1eaf043d4990fa2ed698c87 ("net: convert multicast list to
> list_head") from the net tree and commit
> 8db2022b08e232bb237b2162f03ff5f6e7c0c35e ("staging: arlan: fix errors
> reported by checkpatch.pl tool") from the staging-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

That looks fine, thanks.

greg k-h
