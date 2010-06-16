Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab0FPKtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:49:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab0FPKtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:49:31 -0400
Date: Wed, 16 Jun 2010 06:49:16 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Milan Broz <mbroz@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: remove CONFIG_4KSTACKS
Message-ID: <20100616104916.GV20317@bombadil.infradead.org>
References: <20100616091621.GA4486@lst.de> <20100616112136.42ab08ef@lxorguk.ukuu.org.uk> <20100616102051.GA7731@lst.de> <20100616102307.GU20317@bombadil.infradead.org> <4C18AB9F.2020305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C18AB9F.2020305@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 12:46:55PM +0200, Milan Broz wrote:
> Can you point me to report where 4k stacks is not enough for plain dm-crypt?
> IIRC it was always XFS (maybe ext4) on top of it what caused problem...
> 
> (Anyway, removing 4k stacks is probably good thing:-)
> 

LVM may have been involved as well, I can't recall. I'll try to dig up
the report from my email.

--Kyle
