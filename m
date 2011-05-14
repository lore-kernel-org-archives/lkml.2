Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1ENQbC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:31:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60748 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534Ab1ENQa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mV9CubKrmWPbj79qkS4InIZ4Pm7m5pGyCg7LAB8M4V0ud0sBBEXw65p3KcR4g6+LX3
         EKnxiBlojLre4vtQ6YTlTZwtmqUrSzVgzngIHOYGi9m7wnoUkDVOu4ueY/TEOGxLWl+d
         DBmzkRQagHU8O4NneleLBLSPuxECQOSjzuEu4=
MIME-Version: 1.0
In-Reply-To: <1305295404-12129-2-git-send-email-mgorman@suse.de>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
	<1305295404-12129-2-git-send-email-mgorman@suse.de>
Date: Sun, 15 May 2011 01:30:57 +0900
Message-ID: <BANLkTik7+9TcA0HMgKeMZy-L0R+1RN2_rQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: vmscan: Correct use of pgdat_balanced in sleeping_prematurely
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:03 PM, Mel Gorman <mgorman@suse.de> wrote:
> Johannes Weiner poined out that the logic in commit [1741c877: mm:
> kswapd: keep kswapd awake for high-order allocations until a percentage
> of the node is balanced] is backwards. Instead of allowing kswapd to go
> to sleep when balancing for high order allocations, it keeps it kswapd
> running uselessly.
>
> From-but-was-not-signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Will-sign-off-after-Johannes: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nice catch! Hannes.

-- 
Kind regards,
Minchan Kim
