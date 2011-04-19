Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1DSAJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:09:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37843 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1DSAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:09:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 2/3] tile: replace mm->cpu_vm_mask with mm_cpumask()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <4DAC37E7.5010809@tilera.com>
References: <20110418211914.9361.A69D9226@jp.fujitsu.com> <4DAC37E7.5010809@tilera.com>
Message-Id: <20110419090923.9369.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 19 Apr 2011 09:09:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 4/18/2011 8:18 AM, KOSAKI Motohiro wrote:
> > We plan to change mm->cpu_vm_mask definition later. Thus, this patch convert
> > it into proper macro.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> 
> Thanks; I wasn't aware of this macro.  I'll take this change into my tree
> unless you would like to push it.

Thanks. 

I hope this patch route  your tree. I don't want to push patch 3/3 to linus-tree
until all architecture finish to convert mm_cpumask().


> > Chris, I couldn't get cross compiler for tile. thus I hope you check it carefully.
> 
> The toolchain support is currently only available from Tilera (at
> http://www.tilera.com/scm/) but we are in the process of cleaning it up to
> push it up to the community.

Thank you, too.



