Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab0GMAOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 20:14:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53295 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0GMAOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 20:14:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: FYI: mmap_sem OOM patch
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Divyesh Shah <dpshah@google.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.1007121446500.8468@chino.kir.corp.google.com>
References: <20100708200324.CD4B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1007121446500.8468@chino.kir.corp.google.com>
Message-Id: <20100713091333.EA3E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Jul 2010 09:14:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Jul 2010, KOSAKI Motohiro wrote:
> 
> > I disagree. __GFP_NOFAIL mean this allocation failure can makes really
> > dangerous result. Instead, OOM-Killer should try to kill next process.
> > I think.
> > 
> 
> That's not what happens, __alloc_pages_high_priority() will loop forever 
> for __GFP_NOFAIL, the oom killer is never recalled.

Yup, please reread the discusstion.

