Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0CZFcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 01:32:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58309 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0CZFcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 01:32:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 14/16] Tools perf probe-finder.c: duplicated include
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Gelmini <andrea.gelmini@gelma.net>,
       linux-doc@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4BABA088.2000405@redhat.com>
References: <1269537767-7553-14-git-send-email-andrea.gelmini@gelma.net> <4BABA088.2000405@redhat.com>
Message-Id: <20100326142933.6CA7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Mar 2010 14:32:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Andrea,
> 
> Andrea Gelmini wrote:
> > tools/perf/util/probe-finder.c: string.h is included more than once.
> 
> Would you mean that <string.h> and "string.h" are duplicated? 
> If so, NAK, sorry. Those are different, <string.h> is for
> /usr/include/string.h, and "string.h" is for tools/perf/util/string.h.
> 
> Thank you,

I think this discussion suggested "string.h" should be renameed more review
friendly name. probably.



