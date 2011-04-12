Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1DLXlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:41:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43823 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab1DLXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:41:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: mm: convert vma->vm_flags to 64bit
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
References: <20110412161315.B518.A69D9226@jp.fujitsu.com> <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
Message-Id: <20110413084047.41DD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 08:41:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > After next year? All developers don't have to ignore compiler warnings!
> 
> At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.

Good idea.

> VM_SAO is ppc64 only, so it could be moved into high part,
> freeing 1 bit?

Sure. But It have to be done after two kernel release cycle or so on.
I mean I'm afraid anyone add new vm_flags usage concurrently.



