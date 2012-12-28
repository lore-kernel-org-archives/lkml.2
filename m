Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2L1WBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:01:30 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39748 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2L1WB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:01:28 -0500
MIME-Version: 1.0
In-Reply-To: <1356714442-27028-1-git-send-email-cdall@cs.columbia.edu>
References: <1356714442-27028-1-git-send-email-cdall@cs.columbia.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Dec 2012 14:01:06 -0800
X-Google-Sender-Auth: ilary0VN_VhznrJ9l9lVtjHvU0o
Message-ID: <CA+55aFzaQqe4YEqfJVxwUPW8RyrwZKGzQz6ieFKO_UU=yrnPVA@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
To: c.dall@virtualopensystems.com
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Steve Capper <steve.capper@arm.com>, Will Deacon <will.deacon@arm.com>,
        Andrea Arcangeli <arcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 9:07 AM,  <c.dall@virtualopensystems.com> wrote:
> From: Christoffer Dall <cdall@cs.columbia.edu>
>
> Unfortunately with !CONFIG_PAGEFLAGS_EXTENDED, (!PageHead) is false, and
> (PageHead) is true, for tail pages.  This breaks cache cleaning on some
> ARM systems, and may cause other bugs.

So this already got committed earlier as commit ad4b3fb7ff99 ("mm: Fix
PageHead when !CONFIG_PAGEFLAGS_EXTENDED")

                    Linus
