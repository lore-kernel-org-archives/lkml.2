Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2APL7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:59:39 -0500
Received: from static.213.204.9.176.clients.your-server.de ([176.9.204.213]:40764
	"EHLO shutemov.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2APL7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:59:38 -0500
Date: Mon, 16 Jan 2012 13:59:57 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [RESEND, PATCH 6/6] memcg: cleanup memcg_check_events()
Message-ID: <20120116115957.GB25687@shutemov.name>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
 <1325883472-5614-6-git-send-email-kirill@shutemov.name>
 <20120109134108.GF3588@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109134108.GF3588@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 02:41:08PM +0100, Johannes Weiner wrote:
> On Fri, Jan 06, 2012 at 10:57:52PM +0200, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

...

> I'm about to remove the soft limit part of this code, so we'll be able
> to condense this back into a single #if block again, anyway.
> 
> I would much prefer having the extra #if in the code over this patch
> just to silence the warning for now.

The patch is informative only. I agree with Michal Hocko. It introduce too
much noise to fix one warning. Just ignore it.

-- 
 Kirill A. Shutemov
