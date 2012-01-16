Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2APRUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:20:04 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58225 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2APRUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:20:02 -0500
Message-ID: <4F145AC8.7040307@ah.jp.nec.com>
Date: Mon, 16 Jan 2012 12:13:44 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v3] pagemap handles transparent hugepage
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 01:54:05PM -0800, Andrew Morton wrote:
> On Thu, 12 Jan 2012 14:34:52 -0500
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > Thank you for all your reviews and comments on the previous posts.
> > 
> > In this version, I newly added two patches. One is to separate arch
> > dependency commented by KOSAKI-san, and the other is to introduce
> > new type pme_t as commented by Andrew.
> > And I changed "export KPF_THP" patch to fix an unnoticed bug where
> > both of KPF_THP and with KPF_HUGE are set for hugetlbfs hugepage.
> 
> The patches get a lot of rejects.  I suspect because they were prepared
> against 3.2, thus ignoring all the 3.3 MM changes.  Please redo them
> against current mainline.

OK, I'll post the next version with rebased to 3.3-rc1 (maybe it will be
released later this week.)
