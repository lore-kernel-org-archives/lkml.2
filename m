Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1HOTyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:54:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55467 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1HOTyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:54:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ad0RmN2mp2N/3FUa0Nqnx/+svUL8m0G/AyoT8t7h2Wq7z6P62hSttmiFhZ2nHkzLW
	7tKDUL60+8/ZXgYNJq4PQ==
Date: Mon, 15 Aug 2011 12:53:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
In-Reply-To: <alpine.DEB.2.02.1108151450190.30763@p34.internal.lan>
Message-ID: <alpine.LSU.2.00.1108151240380.1837@sister.anvils>
References: <alpine.DEB.2.02.1108151241370.32349@p34.internal.lan> <alpine.LSU.2.00.1108151109240.1524@sister.anvils> <alpine.DEB.2.02.1108151450190.30763@p34.internal.lan>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, Justin Piszcz wrote:
> On Mon, 15 Aug 2011, Hugh Dickins wrote:
> > 
> > Does it always hit somewhere in find_get_pages(), or does the loop span
> > wider than that?
> Per: http://comments.gmane.org/gmane.linux.kernel/1178570

You've cut the RIP line out of that report, so I cannot see if it's also in
find_get_pages() or not.  I suspect that it is, but nice to see confirmation.

Ah, I missed the "(Continue reading)" button, which reveals "Full output
here": that shows more, and indeed, RIP is at find_get_pages+0x46.

Interesting, but I don't know what's going on here.

Hugh
