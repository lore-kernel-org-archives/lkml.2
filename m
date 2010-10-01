Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab0JADnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 23:43:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58015 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0JADna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 23:43:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 1 Oct 2010 12:38:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH v2] memcg: fix thresholds with use_hierarchy ==
 1
Message-Id: <20101001123814.0b777694.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
References: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 13:16:32 +0300
"Kirill A. Shutsemov" <kirill@shutemov.name> wrote:

> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> We need to check parent's thresholds if parent has use_hierarchy == 1 to
> be sure that parent's threshold events will be triggered even if parent
> itself is not active (no MEM_CGROUP_EVENTS).
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

