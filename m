Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2D1QZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 12:25:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2638 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab2D1QZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 12:25:25 -0400
Message-ID: <4F9C19DB.2050601@parallels.com>
Date: Sat, 28 Apr 2012 20:24:59 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH bugfix] proc/pagemap: correctly report non-present ptes
 and holes between vmas
References: <20120428162229.15658.56316.stgit@zurg>
In-Reply-To: <20120428162229.15658.56316.stgit@zurg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 08:22 PM, Konstantin Khlebnikov wrote:
> This patch resets current pagemap-entry if current pte isn't present,
> or if current vma is over. Otherwise pagemap reports last entry again and again.
> 
> non-present pte reporting was broken in commit v3.3-3738-g092b50b
> ("pagemap: introduce data structure for pagemap entry")
> 
> reporting for holes was broken in commit v3.3-3734-g5aaabe8
> ("pagemap: avoid splitting thp when reading /proc/pid/pagemap")
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Reported-by: Pavel Emelyanov <xemul@parallels.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andi Kleen <ak@linux.intel.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

