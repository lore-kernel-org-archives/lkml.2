Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1I1F7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:59:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46522 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1I1F7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:59:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 14:58:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V10 1/6] mm: frontswap: add frontswap header file
Message-Id: <20110928145848.4cd2cd9d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110915213325.GA26333@ca-server1.us.oracle.com>
References: <20110915213325.GA26333@ca-server1.us.oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 14:33:25 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> This first patch of six in this frontswap series provides the header
> file for the core code for frontswap that interfaces between the hooks
> in the swap subsystem and a frontswap backend via frontswap_ops.
> (Note to earlier reviewers:  This patchset has been reorganized due to
> feedback from Kame Hiroyuki and Andrew Morton. This patch contains part
> of patch 3of4 from the previous series.)
> 
> New file added: include/linux/frontswap.h
> 
> [v10: no change]
> [v9: akpm@linux-foundation.org: change "flush" to "invalidate", part 1]
> [v8: rebase to 3.0-rc4]
> [v7: rebase to 3.0-rc3]
> [v7: JBeulich@novell.com: new static inlines resolve to no-ops if not config'd]
> [v7: JBeulich@novell.com: avoid redundant shifts/divides for *_bit lib calls]
> [v6: rebase to 3.1-rc1]
> [v5: no change from v4]
> [v4: rebase to 2.6.39]
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Jan Beulich <JBeulich@novell.com>
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

