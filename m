Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1IQDoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 23:44:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36268 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752904Ab1IQDo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 23:44:29 -0400
Subject: Re: [PATCH 1/8] page_referenced: replace vm_flags parameter with
 struct pr_info
From: Joe Perches <joe@perches.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>
Date: Fri, 16 Sep 2011 20:44:28 -0700
In-Reply-To: <1316230753-8693-2-git-send-email-walken@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	 <1316230753-8693-2-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316231069.27917.28.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 20:39 -0700, Michel Lespinasse wrote:
> Introduce struct pr_info, passed into page_referenced() family of functions,

pr_info is a pretty commonly used function/macro.
Perhaps pageref_info instead?



