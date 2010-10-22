Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0JVLL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:11:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0JVLL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:11:56 -0400
Date: Fri, 22 Oct 2010 07:11:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] llseek conversion
Message-ID: <20101022111152.GA21969@infradead.org>
References: <201010221310.08449.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010221310.08449.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:10:08PM +0200, Arnd Bergmann wrote:
> There are a few new drivers in linux-next that introduce additional
> file_operations. These can all use no_llseek and I can follow up
> with a patch to make that explicit when they get merged.

I don't think there's any reason to make that explicit.  In fact once
your transition has settled we can just kill no_llseek.

Thanks for doing this work!
