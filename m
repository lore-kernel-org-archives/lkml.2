Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0C3ACY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 20:02:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53472 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0C3ACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 20:02:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 3/3] perf tools: Move the prototypes in util/string.h to util.h
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1269635899-3221-3-git-send-email-acme@infradead.org>
References: <1269635899-3221-1-git-send-email-acme@infradead.org> <1269635899-3221-3-git-send-email-acme@infradead.org>
Message-Id: <20100330090117.8E8D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Mar 2010 09:02:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> So that we avoid conflict with libc's string.h header.
> 
> Suggested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Thank you. I like this :)
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



