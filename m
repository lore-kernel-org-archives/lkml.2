Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0HRPa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:30:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0HRPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:30:25 -0400
Date: Wed, 18 Aug 2010 11:30:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Grundler <grundler@google.com>, Jeff Garzik <jgarzik@pobox.com>,
        Tejun Heo <tj@kernel.org>, Linux IDE <linux-ide@vger.kernel.org>,
        Gwendal Grignou <gwendal@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: Re: [PATCH] V2 2.6.35 libata support for > 512 byte sectors (e.g. 4K
 Native)
Message-ID: <20100818153016.GA6235@infradead.org>
References: <AANLkTinx-cgn7zony8UO__zejj36GxcJTf3Pr2Z9G2af@mail.gmail.com>
 <201008181704.51357.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008181704.51357.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 05:04:51PM +0200, Arnd Bergmann wrote:
> On Tuesday 17 August 2010, Grant Grundler wrote:
> > [ patch NOT inlined because gmail will word-wrap and make a mess of
> > it. Please use attached file.]
> 
> You should be able to use git-send-email with a gmail account to fix this.

Or find an google insider that could fix gmail..

