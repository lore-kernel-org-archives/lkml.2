Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab1BXWLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:11:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab1BXWLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:11:17 -0500
Date: Thu, 24 Feb 2011 14:10:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] hugetlbfs: correct handling of negative input to
 /proc/sys/vm/nr_hugepages
Message-Id: <20110224141034.d2dfb7de.akpm@linux-foundation.org>
In-Reply-To: <4D6419C0.8080804@redhat.com>
References: <4D6419C0.8080804@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 21:17:04 +0100
Petr Holasek <pholasek@redhat.com> wrote:

> When user insert negative value into /proc/sys/vm/nr_hugepages it will 
> result
> in the setting a random number of HugePages in system

Is this true?  afacit the kernel will allocate as many pages as it can
and will then set /proc/sys/vm/nr_hugepages to reflect the result. 
That's not random.

