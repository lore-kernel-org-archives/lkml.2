Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab1DLWHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:07:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:32851 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab1DLWHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:07:48 -0400
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
	 <20110411233358.dd400e59.akpm@linux-foundation.org>
	 <20110412161315.B518.A69D9226@jp.fujitsu.com>
	 <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 08:07:04 +1000
Message-ID: <1302646024.28876.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 14:06 +0300, Alexey Dobriyan wrote:
> On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > After next year? All developers don't have to ignore compiler warnings!
> 
> At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.
> 
> VM_SAO is ppc64 only, so it could be moved into high part,
> freeing 1 bit?

My original series did use a type, I don't know what that was dropped,
it made conversion easier imho.

Cheers,
Ben.


