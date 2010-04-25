Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0DYQ5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 12:57:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0DYQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 12:57:37 -0400
Date: Sun, 25 Apr 2010 12:57:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Hans-Peter Jansen <hpj@urpla.net>, Nick Piggin <npiggin@suse.de>,
       opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100425165734.GA2887@infradead.org>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard> <201004131142.33518.hpj@urpla.net> <201004241844.23482.hpj@urpla.net> <20100425162740.GB19195@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100425162740.GB19195@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 09:27:40AM -0700, Greg KH wrote:
> On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> > FYI, 2.6.33.2 is still affected from this issue. 
> 
> Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
> 2.6.32.12-rc2.)

Yes.  It's not even in mainline yet as Nick doesn't like the trivial
core VM fix required to solve this in a clean way.
