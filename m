Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab1DMIeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:34:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59249 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab1DMIem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:34:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: mm: convert vma->vm_flags to 64bit
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <1302678049.28876.77.camel@pasglop>
References: <20110413064432.GA4098@p183> <1302678049.28876.77.camel@pasglop>
Message-Id: <20110413173453.D734.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 17:34:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2011-04-13 at 09:44 +0300, Alexey Dobriyan wrote:
> > > Yes, I take Hugh's version because vm_flags_t is ugly to me. And
> > arch 
> > > dependent variable size is problematic.
> > 
> > Who said it should have arch-dependent size? 
> 
> Right, it shouldn't. My original patch did that to avoid thinking about
> archs that manipulated it from asm such as ARM but that wasn't the right
> thing to do. But that doesn't invalidate having a type.

type or not type is really cosmetic matter. Then, only if Andrew or Hugh
or another active MM developers strongly requrest to make a type, I'll do.
But, now I haven't hear it.

In short, When both are right code, I prefer to take MM developers preference.
That's MM code. This is the reason why I taked Hugh's choice.

Thanks.


