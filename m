Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1EPXFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:05:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64101 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab1EPXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ghpo9m0iEFoOf0ti/8gWzlxLv12+shFiz2oazGRwekoTGiP5PjPYGvx0K7bKSDKPVK
         MpUSbvW9BnfMuy2A4WPBGzZGjc4WKvZ3EEfC2gLK/GYJ0IdYPTq2EtmhcpVYiEDqGwTi
         QGUTnPnduFB5wiUzlKfryEOnIe1ZVP1qpgAL0=
MIME-Version: 1.0
In-Reply-To: <1305558417-24354-2-git-send-email-mgorman@suse.de>
References: <1305558417-24354-1-git-send-email-mgorman@suse.de>
	<1305558417-24354-2-git-send-email-mgorman@suse.de>
Date: Tue, 17 May 2011 08:05:39 +0900
Message-ID: <BANLkTikyATUVyYpY+SS_Py3DV18-L92GTg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: vmscan: Correct use of pgdat_balanced in sleeping_prematurely
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
        linux-ext4 <linux-ext4@vger.kernel.org>, stable <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 12:06 AM, Mel Gorman <mgorman@suse.de> wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
>
> Johannes Weiner poined out that the logic in commit [1741c877: mm:
> kswapd: keep kswapd awake for high-order allocations until a percentage
> of the node is balanced] is backwards. Instead of allowing kswapd to go
> to sleep when balancing for high order allocations, it keeps it kswapd
> running uselessly.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
