Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0FUVdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:33:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab0FUVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:33:14 -0400
Date: Mon, 21 Jun 2010 17:33:09 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Miller <davem@davemloft.net>
Cc: deller@gmx.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-parisc@vger.kernel.org, kyle@mcmartin.ca, jpirko@redhat.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] lasi82596: fix netdev_mc_count conversion
Message-ID: <20100621213309.GB20317@bombadil.infradead.org>
References: <20100619223524.GA6018@p100.box> <20100619224139.GA6158@p100.box> <20100621.135050.48492866.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621.135050.48492866.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 01:50:50PM -0700, David Miller wrote:
> From: Helge Deller <deller@gmx.de>
> Date: Sun, 20 Jun 2010 00:41:39 +0200
> 
> > Fix commit 4cd24eaf0 (net: use netdev_mc_count and netdev_mc_empty when
> > appropriate)
> > 
> > Signed-off-by: Helge Deller <deller@gmx.de>
> 
> Applied, please CC: netdev@vger.kernel.org when posting networking
> patches in the future, thanks.
> 

Thanks for catching this, Dave.

--Kyle
