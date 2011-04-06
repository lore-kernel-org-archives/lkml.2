Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1DFW0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:26:31 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:51092 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756493Ab1DFW0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:26:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALrnnE15LHHJ/2dsb2JhbACESqE0eLJ2kRQNgRuDTHgEk1U
Date: Thu, 7 Apr 2011 08:26:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com,
        Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unused 'bdi' variable in
 xfs_buf_readahead()
Message-ID: <20110406222624.GG31057@dastard>
References: <alpine.LNX.2.00.1104061311450.5855@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1104061311450.5855@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 01:15:50PM -0700, Jiri Kosina wrote:
> Gets rid of 
> 
> 	fs/xfs/linux-2.6/xfs_buf.c: In function ‘xfs_buf_readahead’:
> 	fs/xfs/linux-2.6/xfs_buf.c:660: warning: unused variable ‘bdi’
> 
> The variable has been unused since 0e6e847ffe ("xfs: stop using the page 
> cache to back the buffer cache")

There's already a patch in the XFS tree for this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
