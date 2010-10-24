Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab0JXQNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:13:44 -0400
Received: from verein.lst.de ([213.95.11.210]:55695 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0JXQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:13:43 -0400
Date: Sun, 24 Oct 2010 18:13:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Milan Broz <mbroz@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org
Subject: Re: loop warnings in current git HEAD
Message-ID: <20101024161323.GA32405@lst.de>
References: <20101023155950.GA31946@lst.de> <4CC4043F.1070605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC4043F.1070605@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 12:02:39PM +0200, Milan Broz wrote:
> yes, seems I forgot bdev can be NULL in destructor (autoclear mode).
> can you try if patch below helps?

Yes, this patch seems to fix the issue for me.

