Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab0LBBWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:22:20 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35641 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0LBBWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:22:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012010859020.2849@router.home>
References: <20101130142509.4f49d452.akpm@linux-foundation.org> <alpine.DEB.2.00.1012010859020.2849@router.home>
Message-Id: <20101202102110.157F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Dec 2010 10:22:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 30 Nov 2010, Andrew Morton wrote:
> 
> > > +#define UNMAPPED_PAGE_RATIO 16
> >
> > Well.  Giving 16 a name didn't really clarify anything.  Attentive
> > readers will want to know what this does, why 16 was chosen and what
> > the effects of changing it will be.
> 
> The meaning is analoguous to the other zone reclaim ratio. But yes it
> should be justified and defined.
> 
> > > Reviewed-by: Christoph Lameter <cl@linux.com>
> >
> > So you're OK with shoving all this flotsam into 100,000,000 cellphones?
> > This was a pretty outrageous patchset!
> 
> This is a feature that has been requested over and over for years. Using
> /proc/vm/drop_caches for fixing situations where one simply has too many
> page cache pages is not so much fun in the long run.

I'm not against page cache limitation feature at all. But, this is
too ugly and too destructive fast path. I hope this patch reduce negative
impact more.


