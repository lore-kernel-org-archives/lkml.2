Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0KUPVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:21:43 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46837 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab0KUPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=Jl2XShlbrArycgaocaQS1Nqk4l+0wcdONBmZwTkgoCC6cg9JziFjJAHILjw7ocHM+6
         WQUjgCmk6/HCpYMW0dZTV5Sak7jAplcDxjGgpBdcOZJDgWxWgGBzvRlTPSIGR1JWrlA+
         8CfbMgfdfiv1CwyYwdm9CDgV3b99Ej8Fhm+2Y=
From: Ben Gamari <bgamari@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 1/2] deactive invalidated pages
In-Reply-To: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 21 Nov 2010 10:21:34 -0500
Message-ID: <874obawvlt.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 23:30:23 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> Ben, Remain thing is to modify rsync and use
> fadvise(POSIX_FADV_DONTNEED). Could you test it?

Thanks a ton for the patch. Looks good. Testing as we speak.

- Ben
