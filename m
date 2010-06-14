Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0FNQUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:20:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0FNQUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:20:50 -0400
Date: Mon, 14 Jun 2010 12:20:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: iwlagn completely unusable with some AP since 2.6.31
Message-ID: <20100614162048.GA28894@infradead.org>
References: <20100614160910.GA10738@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614160910.GA10738@gandalf.dynalias.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 01:09:10AM +0900, Norbert Preining wrote:
> Dear all,
> 
> (please cc)
> 
> Since AFAIR 2.6.32-rc the iwlagn driver seems to be completely hosed
> with some AP. Permanently dropping connections, hanging, BUGing.
> Unfortunately the only reply I get from iwl maintainers is "do git bisect"
> which is a bit a pain with someting that is not stable reproducible.

I see the same issue, and I even tried the git bisect, but due to
various issues in early boot / ACPI code in that merge window it's
impossible to finish it.  The ugly workaround for me is to always keep
a ping running in the background, which keeps it from dropping the
connection.  Fortunately the BUGs only happen very rarely for me (and
unfortunately I'm not able to capture them, but I suspect it's iwlagn)

