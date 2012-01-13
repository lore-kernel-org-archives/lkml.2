Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab2AMVyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:54:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2AMVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:54:12 -0500
Date: Fri, 13 Jan 2012 13:54:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v3] pagemap handles transparent hugepage
Message-Id: <20120113135405.15d9f69f.akpm@linux-foundation.org>
In-Reply-To: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 14:34:52 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Thank you for all your reviews and comments on the previous posts.
> 
> In this version, I newly added two patches. One is to separate arch
> dependency commented by KOSAKI-san, and the other is to introduce
> new type pme_t as commented by Andrew.
> And I changed "export KPF_THP" patch to fix an unnoticed bug where
> both of KPF_THP and with KPF_HUGE are set for hugetlbfs hugepage.

The patches get a lot of rejects.  I suspect because they were prepared
against 3.2, thus ignoring all the 3.3 MM changes.  Please redo them
against current mainline.

Andrea, have you reviewed this work?  If not, could you please try to
do so?

