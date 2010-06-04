Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0FDKyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:54:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51293 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0FDKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:54:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 09/12] oom: remove PF_EXITING check completely
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.2.00.1006022332320.22441@chino.kir.corp.google.com>
References: <20100603152436.7262.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006022332320.22441@chino.kir.corp.google.com>
Message-Id: <20100604092414.7292.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Jun 2010 19:54:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Acked-by: Oleg Nesterov <oleg@redhat.com>
> 
> Nacked-by: David Rientjes <rientjes@google.com>
> 
> You have no real world experience in using the oom killer for memory 
> containment and don't understand how critical it is to protect other 
> vital system tasks that are needlessly killed as the result of this patch.

Heh, You really think "you have no experience" takes meaningful argument?
If I'd say "You have no real world experience in using linux", you are
satisfied?

Anyway, I don't care such "Please don't fix the bug" claim. the bug is
bug. not something else.



