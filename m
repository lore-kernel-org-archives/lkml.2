Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1EJIEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:04:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab1EJIEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:04:44 -0400
Date: Tue, 10 May 2011 04:04:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/14] HPFS: Fix endianity. Make hpfs work on big-endian
 machines
Message-ID: <20110510080443.GD13420@infradead.org>
References: <alpine.DEB.2.00.1105082030020.7013@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105082030020.7013@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 08:44:26PM +0200, Mikulas Patocka wrote:
> Fix endianity. Make hpfs work on big-endian machines.

Please also use the __le* types and test the endianess handling using
sparse.

