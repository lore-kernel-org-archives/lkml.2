Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2FWT1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 15:27:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37275 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2FWT1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 15:27:10 -0400
Date: Sat, 23 Jun 2012 21:27:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH] Use -mpreferred-stack-boundary=3 on x86-64 if supported
Message-ID: <20120623192704.GT11413@one.firstfloor.org>
References: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com> <20120623161324.GS11413@one.firstfloor.org> <24bd04a1-1702-4d57-af64-af2381992789@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24bd04a1-1702-4d57-af64-af2381992789@email.android.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 09:17:06AM -0700, H. Peter Anvin wrote:
> To keep gcc from paddong the stack to maintain a nonexistent alignment.


Ah ok. 3 instead of 4.

I thought i had done that a long time ago, but now it somehow
only seems to be there for 32bit.

Makes sense.

-Andi
