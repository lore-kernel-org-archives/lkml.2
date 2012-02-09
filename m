Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab2BICZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:25:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35992 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab2BICZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:25:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Feb 2012 11:24:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] introduce pmd_to_pte_t()
Message-Id: <20120209112414.85d65fc0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1328716302-16871-6-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1328716302-16871-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1328716302-16871-6-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 10:51:41 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Casting pmd into pte_t to handle thp is strongly architecture dependent.
> This patch introduces a new function to separate this dependency from
> independent part.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

