Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967387Ab2EPFCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:02:50 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:15925 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967306Ab2EPFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:02:47 -0400
Date: Wed, 16 May 2012 07:02:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the net-next tree with the
	sparc-next tree
Message-ID: <20120516050245.GA407@merkur.ravnborg.org>
References: <20120516143944.57a648287aa5cd1a5930254e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516143944.57a648287aa5cd1a5930254e@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 02:39:44PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> arch/sparc/Makefile between commit e1d7de8377e6 ("sparc: introduce
> arch/sparc/Kbuild") from the sparc-next tree and commit 2809a2087cc4
> ("net: filter: Just In Time compiler for sparc") from the net-next tree.
> 
> I suspect that the core-y net bit below should be changed to be a obj-y
> bit of arch/sparc/Kbuild ...

Correct - like this:

arch/sparc/Kbuild:

obj-y += net/

	Sam
