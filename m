Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1CNRaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:30:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3222 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1CNRa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qBg+WqGkgafeuPe5td/ayZaMA7/TQK/JUvJecE4yoAS8aUp42+WupWZ0M4ARHOZ5YW
         GNHyub3IKV/fGfMmQAbw==
Date: Mon, 14 Mar 2011 10:30:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Mel Gorman <mgorman@suse.de>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: swap: Unlock swapfile inode mutex before closing
 file on bad swapfiles
In-Reply-To: <20110314122746.GA32408@suse.de>
Message-ID: <alpine.LSU.2.00.1103141026480.2894@sister.anvils>
References: <20110314122746.GA32408@suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Mel Gorman wrote:

> This patch releases the mutex if its held before calling filep_close()
> so swapon fails as expected without deadlock when the swapfile is backed
> by NFS.  If accepted for 2.6.39, it should also be considered a -stable
> candidate for 2.6.38 and 2.6.37.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Hugh Dickins <hughd@google.com>

Thank you!
