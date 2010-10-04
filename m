Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0JDI3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:29:52 -0400
Received: from verein.lst.de ([213.95.11.210]:55220 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0JDI3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:29:51 -0400
Date: Mon, 4 Oct 2010 10:29:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the bkl-trivial tree with the hfsplus tree
Message-ID: <20101004082944.GA15480@lst.de>
References: <20101004104740.822b987d.sfr@canb.auug.org.au> <20101004033441.GA6867@lst.de> <201010041023.45694.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010041023.45694.arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 10:23:45AM +0200, Arnd Bergmann wrote:
> Christoph, are you planning to take care of freevxfs, too? I can't figure
> out whether readdir and lookup actually need locking there.

They shouldn't, but I'll take a look.

