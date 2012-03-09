Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab2CIBbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:31:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44774 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2CIBbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:31:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 10:30:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] mm: rework __isolate_lru_page() page lru filter
Message-Id: <20120309103006.2450d02d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120308180415.27621.23390.stgit@zurg>
References: <20120308175752.27621.54781.stgit@zurg>
	<20120308180415.27621.23390.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 22:04:15 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch adds lru bit mask into lower byte of isolate_mode_t,
> this allows to simplify checks in __isolate_lru_page().
> 
> v5:
> * lru bit mask instead of special file/anon active/inactive bits
> * mark page_lru() as __always_inline, it helps gcc generate more compact code
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 

Nice !

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


