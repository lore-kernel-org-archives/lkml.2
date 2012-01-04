Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2ADX5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:57:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2ADX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:57:53 -0500
Date: Wed, 4 Jan 2012 15:57:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pagemap: document KPF_THP and make page-types aware
 of it
Message-Id: <20120104155752.86435535.akpm@linux-foundation.org>
In-Reply-To: <1324506228-18327-5-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1324506228-18327-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1324506228-18327-5-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 17:23:48 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> page-types, which is a common user of pagemap, gets aware of thp
> with this patch. This helps system admins and kernel hackers know
> about how thp works.
> Here is a sample output of page-types over a thp:

Oh, there it is.

It would be nice to generate a /proc/pid/pagemap test for the forthcoming
tools/testing/selftests/.  But I guess page-types.c is good
enough for now.
