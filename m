Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab0JDDeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 23:34:50 -0400
Received: from verein.lst.de ([213.95.11.210]:49380 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab0JDDet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 23:34:49 -0400
Date: Mon, 4 Oct 2010 05:34:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the bkl-trivial tree with the hfsplus tree
Message-ID: <20101004033441.GA6867@lst.de>
References: <20101004104740.822b987d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004104740.822b987d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 10:47:40AM +1100, Stephen Rothwell wrote:
> Hi Arnd,
> 
> The second of the hfsplus tree commits seems to supercede the bkl-trivial
> one, so I used that.

Yes, the hfsplus tree contains a proper BKL removal for hfsplus.

