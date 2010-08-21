Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0HUKgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 06:36:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0HUKgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 06:36:40 -0400
Date: Sat, 21 Aug 2010 06:36:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 04/10] ioctl: Use asm-generic/ioctls.h on frv (enables
 termiox)
Message-ID: <20100821103638.GB10671@infradead.org>
References: <20100820211401.651509182@suse.com>
 <20100820211538.515791797@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820211538.515791797@suse.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 05:14:05PM -0400, Jeff Mahoney wrote:
> This patch converts frv to use asm-generic/ioctls.h instead of its
> own version.
> 
> The differences between the arch-specific version and the generic
> version are as follows:
> 
> - FRV defines its own value for FIOQSIZE, asm-generic/ioctls.h keeps it
> - FRV defines TIOCTTYGSTRUCT, kept in arch-specific version

This is an ioctl that used be implemented in generic code and then
was removed.  I looks like a couple of ports added after the removal
kept the defintion anyway.  Just kill it from all of them.

