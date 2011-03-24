Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab1CXAHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:07:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36411 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab1CXAHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:07:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 2/5] Revert "oom: give the dying task a higher priority"
Cc: kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <20110323134037.GP5212@uudg.org>
References: <20110323164229.6b647004.kamezawa.hiroyu@jp.fujitsu.com> <20110323134037.GP5212@uudg.org>
Message-Id: <20110324090635.1AEC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 09:06:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Mar 23, 2011 at 04:42:29PM +0900, KAMEZAWA Hiroyuki wrote:
> | On Tue, 22 Mar 2011 20:06:48 +0900 (JST)
> | KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> | 
> | > This reverts commit 93b43fa55088fe977503a156d1097cc2055449a2.
> | > 
> | > The commit dramatically improve oom killer logic when fork-bomb
> | > occur. But, I've found it has nasty corner case. Now cpu cgroup
> | > has strange default RT runtime. It's 0! That said, if a process
> | > under cpu cgroup promote RT scheduling class, the process never
> | > run at all.
> | > 
> | > Eventually, kernel may hang up when oom kill occur.
> | > 
> | > The author need to resubmit it as adding knob and disabled
> | > by default if he really need this feature.
> | > 
> | > Cc: Luis Claudio R. Goncalves <lclaudio@uudg.org>
> | > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> | 
> | Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> The original patch was written to fix an issue observed in 2.6.24.7-rt.
> As the logic sounded useful, I ported it to upstream. Anyway,I am trying
> a few ideas to rework that patch. In the meantime, I'm pretty fine with
> reverting the commit.
> 
> Acked-by: Luis Claudio R. Gonçalves <lgoncalv@uudg.org>

Ok, and then, I'll drop [patch 3/5] too. I hope to focus to discuss your idea.




