Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab0FPKXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:23:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0FPKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:23:15 -0400
Date: Wed, 16 Jun 2010 06:23:07 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: remove CONFIG_4KSTACKS
Message-ID: <20100616102307.GU20317@bombadil.infradead.org>
References: <20100616091621.GA4486@lst.de> <20100616112136.42ab08ef@lxorguk.ukuu.org.uk> <20100616102051.GA7731@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616102051.GA7731@lst.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 12:20:51PM +0200, Christoph Hellwig wrote:
> > Perhaps XFS should select 8K stack instead ?
> 
> or rather !CONFIG_INSANE.  I don't care too much.  No one sane should
> ever enable it anymore, but Ingo asked me to send a patch to remove it.
> 

Alan--

It's not just XFS, we were regularly seeing blown stacks on Fedora with
ext3/4 and encrypted disks using dm-crypt...

--Kyle
