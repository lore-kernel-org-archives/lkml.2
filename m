Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab2C2JbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:31:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60784 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2C2JbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:31:17 -0400
Date: Thu, 29 Mar 2012 10:31:13 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Subject: Re: Patch "mm: vmscan: forcibly scan highmem if there are too many
 buffer_heads pinning highmem" has been added to the 3.3-stable tree
Message-ID: <20120329093113.GR1007@csn.ul.ie>
References: <13325234973644@kroah.org>
 <20120329053639.GA7603@pcnci2.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120329053639.GA7603@pcnci2.linuxbox.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 07:36:39AM +0200, Nikola Ciprich wrote:
> Hi,
> 
> I'm not 100% sure, but I think this one could go to 3.0.x as well, am I right?
> If it's so, could I try to provide backport? (it't doesn't apply cleanly).

If you want to try a backport go right ahead. There is an indirect dependency
on [2bcf8879: mm: take pagevecs off reclaim stack] which is not suitable
for backporting to -stable but handling that should be easy.

> Mel, would You care to review then? Or do You plan to send Your own backport?
> 

I had not planned my own backport because the type of bug made it a low
priority for me (copying NTFS with small block size on 32 bit X86 with 16G
of RAM). If you backport it, I'll review the result. I will be at LSF/MM next
week so I might be a bit slow to respond but I'll get around to it. Thanks.

-- 
Mel Gorman
SUSE Labs
