Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1DMHE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:04:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57035 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab1DMHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:04:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: mm: convert vma->vm_flags to 64bit
Cc: kosaki.motohiro@jp.fujitsu.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <20110413064432.GA4098@p183>
References: <20110413091301.41E1.A69D9226@jp.fujitsu.com> <20110413064432.GA4098@p183>
Message-Id: <20110413160455.D72E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 16:04:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 13, 2011 at 09:13:03AM +0900, KOSAKI Motohiro wrote:
> > > On Tue, 2011-04-12 at 14:06 +0300, Alexey Dobriyan wrote:
> > > > On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
> > > > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > > After next year? All developers don't have to ignore compiler warnings!
> > > > 
> > > > At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.
> > > > 
> > > > VM_SAO is ppc64 only, so it could be moved into high part,
> > > > freeing 1 bit?
> > > 
> > > My original series did use a type, I don't know what that was dropped,
> > > it made conversion easier imho.
> > 
> > Yes, I take Hugh's version because vm_flags_t is ugly to me. And arch 
> > dependent variable size is problematic.
> 
> Who said it should have arch-dependent size?

Ben's patch had arch-dependent size.



