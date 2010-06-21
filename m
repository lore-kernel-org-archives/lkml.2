Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0FULrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:47:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58885 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab0FULq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:46:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 6/9] oom: unify CAP_SYS_RAWIO check into other superuser check
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1006162118160.14101@chino.kir.corp.google.com>
References: <20100617104756.FB8F.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006162118160.14101@chino.kir.corp.google.com>
Message-Id: <20100621204605.B545.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 21 Jun 2010 20:46:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:
> 
> > 
> > Now, CAP_SYS_RAWIO check is very strange. if the user have both
> > CAP_SYS_ADMIN and CAP_SYS_RAWIO, points will makes 1/16.
> > 
> > Superuser's 1/4 bonus worthness is quite a bit dubious, but
> > considerable. However 1/16 is obviously insane.
> > 
> 
> This is already obsoleted by the heuristic rewrite that is already under 
> review.

Huh? I don't think this patch conflict against your. but I'm ok to pending
awhile.


