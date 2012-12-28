Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2L1WVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:21:02 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:33127 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2L1WVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:21:00 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzaQqe4YEqfJVxwUPW8RyrwZKGzQz6ieFKO_UU=yrnPVA@mail.gmail.com>
References: <1356714442-27028-1-git-send-email-cdall@cs.columbia.edu>
	<CA+55aFzaQqe4YEqfJVxwUPW8RyrwZKGzQz6ieFKO_UU=yrnPVA@mail.gmail.com>
Date: Fri, 28 Dec 2012 17:20:58 -0500
X-Google-Sender-Auth: qQGOXM2dD3eujWOxYyL5ATL7kXU
Message-ID: <CAEDV+gJV+90jUQgc5iEotUXMVhx5PYv8zWsUHzKFLpj-8uxQ5A@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
From: Christoffer Dall <cdall@cs.columbia.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrea Arcangeli <arcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 5:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Dec 28, 2012 at 9:07 AM,  <c.dall@virtualopensystems.com> wrote:
>> From: Christoffer Dall <cdall@cs.columbia.edu>
>>
>> Unfortunately with !CONFIG_PAGEFLAGS_EXTENDED, (!PageHead) is false, and
>> (PageHead) is true, for tail pages.  This breaks cache cleaning on some
>> ARM systems, and may cause other bugs.
>
> So this already got committed earlier as commit ad4b3fb7ff99 ("mm: Fix
> PageHead when !CONFIG_PAGEFLAGS_EXTENDED")
>
>                     Linus

Sorry about the noise then, thanks.
