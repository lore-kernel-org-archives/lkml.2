Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2AIRaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:30:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40197 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2AIRaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:30:15 -0500
Date: Mon, 9 Jan 2012 17:30:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        david@fromorbit.com
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120109173010.GX23916@ZenIV.linux.org.uk>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
 <20120109171639.GA9359@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109171639.GA9359@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 12:16:39PM -0500, Christoph Hellwig wrote:
> Dave's patch from August in which removes the whole select_parent lru abuse
> should fix this to, and actually clean up that area.  It will probably
> need a rebase as it was near the end of a larger series.  We probably
> want the patch directly following it in the series, too.

Resend would be nice; I can try to dig the series out and rebase it, but...
