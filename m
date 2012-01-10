Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab2AJSFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:05:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59454 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab2AJSFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:05:18 -0500
Date: Tue, 10 Jan 2012 18:05:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] vfs: fix shrink_dcache_parent() livelock
Message-ID: <20120110180515.GD23916@ZenIV.linux.org.uk>
References: <87k44zdbjm.fsf@tucsk.pomaz.szeredi.hu>
 <87fwfncw1a.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwfncw1a.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 06:22:25PM +0100, Miklos Szeredi wrote:
> Set flag in prune_dcache_sb() for consistency.  Add stable@ to cc.
> 
> Please apply.

Done.
