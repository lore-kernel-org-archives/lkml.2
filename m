Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab0JPQcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:32:09 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55172 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0JPQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:32:08 -0400
Date: Sat, 16 Oct 2010 12:32:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] kernel: add bl_list
Message-ID: <20101016163206.GE20086@infradead.org>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-3-git-send-email-david@fromorbit.com>
 <20101016095150.GA7142@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016095150.GA7142@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 08:51:50PM +1100, Nick Piggin wrote:
> I don't know why Christoph asked for these; he's usually against
> obfuscating wrapper functions.
> 
> bit_spin_lock is fine in callers so please leave it at that.
> Other users may not want a spinlock, or might want to use
> bit_spin_is_locked, bit_spin_trylock etc.

See the comments on the previous posting of this.  It provides a useful
abtraction.  And yes, eventually we might need more wrappers, but
we can add them as needed.

