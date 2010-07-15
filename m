Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991Ab0GOXSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:18:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40381 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934966Ab0GOXSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:18:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Jul 2010 08:13:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org,
        Adrien Dessemond <adrien.dessemond@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] kmemleak: Annotate false positive in
 init_section_page_cgroup()
Message-Id: <20100716081333.01efcc83.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100715150117.21293.45752.stgit@e102109-lin.cambridge.arm.com>
References: <20100715150117.21293.45752.stgit@e102109-lin.cambridge.arm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 16:01:17 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> The pointer to the page_cgroup table allocated in
> init_section_page_cgroup() is stored in section->page_cgroup as (base -
> pfn). Since this value does not point to the beginning or inside the
> allocated memory block, kmemleak reports a false positive.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: Adrien Dessemond <adrien.dessemond@gmail.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you!.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

