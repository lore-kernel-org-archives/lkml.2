Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2FWQNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 12:13:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37220 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2FWQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 12:13:31 -0400
Date: Sat, 23 Jun 2012 18:13:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH] Use -mpreferred-stack-boundary=3 on x86-64 if supported
Message-ID: <20120623161324.GS11413@one.firstfloor.org>
References: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch uses -mpreferred-stack-boundary=3 on x86-64 if it is supported.
> I have been running 3.4 kernel compiled with this option for weeks.

But why? 

All the SSE code in the kernel should adjust manually. And the other
code doesn't need it.

Besides the entry points do not guarantee alignment.

For the kernel it would be probably more useful to have a attribute
per function that forces alignment.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
