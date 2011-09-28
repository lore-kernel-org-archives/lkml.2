Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1I1G3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:29:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45893 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1I1G3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:29:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 15:28:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 1/9] page_referenced: replace vm_flags parameter with
 struct page_referenced_info
Message-Id: <20110928152842.dba85ed0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317170947-17074-2-git-send-email-walken@google.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-2-git-send-email-walken@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 17:48:59 -0700
Michel Lespinasse <walken@google.com> wrote:

> Introduce struct page_referenced_info, passed into page_referenced() family
> of functions, to represent information about the pte references that have
> been found for that page. Currently contains the vm_flags information as
> well as a PR_REFERENCED flag. The idea is to make it easy to extend the API
> with new flags.
> 
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

