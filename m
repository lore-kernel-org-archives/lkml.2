Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0HZSsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:48:42 -0400
Received: from xenotime.net ([72.52.115.56]:33751 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751826Ab0HZSsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:48:41 -0400
Date: Thu, 26 Aug 2010 11:48:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Docbook: allow warning on unused documentation
Message-Id: <20100826114830.4f7e116e.rdunlap@xenotime.net>
In-Reply-To: <1282844594.3812.74.camel@jlt3.sipsolutions.net>
References: <1282136967.13315.1.camel@jlt3.sipsolutions.net>
	<20100826093710.111b103e.rdunlap@xenotime.net>
	<1282841476.3812.69.camel@jlt3.sipsolutions.net>
	<20100826101130.61f60090.rdunlap@xenotime.net>
	<1282844594.3812.74.camel@jlt3.sipsolutions.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 19:43:14 +0200 Johannes Berg wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> When you don't use !E or !I but only !F, then
> it's very easy to miss including some functions,
> structs etc. in documentation. To help finding
> which ones were missed, allow printing out the
> unused ones as warnings.
> 
> For example, using this on mac80211 yields a
> lot of warnings like this:
> 
>   Warning: didn't use docs for DOC: mac80211 workqueue
>   Warning: didn't use docs for ieee80211_max_queues
>   Warning: didn't use docs for ieee80211_bss_change
>   Warning: didn't use docs for ieee80211_bss_conf
> 
> when generating the documentation for it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: - fix comment
>     - use !C instead of !A
> 
>  Documentation/kernel-doc-nano-HOWTO.txt |    5 +
>  scripts/basic/docproc.c                 |  129 +++++++++++++++++++++++++++++++-
>  scripts/kernel-doc                      |   52 ++++++++++++
>  3 files changed, 183 insertions(+), 3 deletions(-)

Applied, thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
