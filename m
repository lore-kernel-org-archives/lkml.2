Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2AIOEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:04:15 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:37208 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2AIOEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:04:14 -0500
Date: Mon, 9 Jan 2012 15:04:04 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        stable@kernel.org
Subject: Re: [RESEND, PATCH 4/6] memcg: fix broken boolean expression
Message-ID: <20120109140404.GG3588@cmpxchg.org>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
 <1325883472-5614-4-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325883472-5614-4-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 10:57:50PM +0200, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: <stable@kernel.org>

I think you don't need to actually CC stable via email.  If you
include that tag, they will pick it up once the patch hits mainline.

The changelog is too terse, doubly so for a patch that should go into
stable.  How is the code supposed to work?  What are the consequences
of the bug?
