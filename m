Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0GENIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:08:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:52598 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab0GENIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:08:22 -0400
Subject: Re: [PATCH 0/1] VFS: introduce s_dirty accessors
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
References: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 16:04:27 +0300
Message-ID: <1278335067.29620.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jul 2010 13:08:04.0596 (UTC) FILETIME=[1AAA8340:01CB1C43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 13:56 +0300, Artem Bityutskiy wrote:
> Hi Linus,
> 
> would it be possible to add the following patch to your tree. I'm trying
> to lessen amount of useless wake-ups in the kernel, and the 'sync_supers'
> thread if one of those kernel threads which wakes up every 5 seconds to
> (mostly) do nothing.
> 
> This is still work in progress, but putting the below patch to your tree
> would make life easier at the next merge window. This patch just adds 3
> accessor functions, but no one will use them so fare, so it must be
> harmless. This was suggested by Ted and supported by Al:
> http://lkml.org/lkml/2010/6/9/216

Linus,

I wonder, you did not take this because of the vacation or because you
do not like it?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

