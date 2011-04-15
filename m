Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1DOFdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:33:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33468 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1DOFdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:33:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] make sparse happy with gfp.h
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1302844066.16562.1953.camel@nimitz>
References: <20110415121424.F7A6.A69D9226@jp.fujitsu.com> <1302844066.16562.1953.camel@nimitz>
Message-Id: <20110415143259.F7BD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 15 Apr 2011 14:33:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On Fri, 2011-04-15 at 12:14 +0900, KOSAKI Motohiro wrote:
> > >  #ifdef CONFIG_DEBUG_VM
> > > -             BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > > +     BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > >  #endif
> > > -     }
> > >       return z;
> > 
> > Why don't you use VM_BUG_ON?
> 
> I was just trying to make a minimal patch that did a single thing.
> 
> Feel free to submit another one that does that.  I'm sure there are a
> couple more places that could use similar love.

I posted another approach patches a second ago. Could you please see it?



