Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1D2G0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 02:26:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152Ab1D2GZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 02:25:58 -0400
Date: Thu, 28 Apr 2011 23:31:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: large cross tree spelling fixes
Message-Id: <20110428233111.3ca7b04f.akpm@linux-foundation.org>
In-Reply-To: <20110428130427.06925753.sfr@canb.auug.org.au>
References: <20110428130427.06925753.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 13:04:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
> 
> Next time you are tempted to take one of these, please resist. :-)
> 
> It was not urgent, could have been (at least) broken up and sent to the
> respective maintainers, and caused many conflicts in linux-next (which
> either means unnecessary rebases/merges or you will see the conflicts
> next merge window).

Probably the best time for this sort of thing is immediately after
-rc1, when everyone's out-of-tree trees are the smallest.

