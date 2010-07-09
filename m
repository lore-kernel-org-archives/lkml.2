Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab0GIBb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:31:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32904 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0GIBb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:31:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: FYI: mmap_sem OOM patch
Cc: kosaki.motohiro@jp.fujitsu.com, Michel Lespinasse <walken@google.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1278588200.1900.89.camel@laptop>
References: <20100708200324.CD4B.A69D9226@jp.fujitsu.com> <1278588200.1900.89.camel@laptop>
Message-Id: <20100709102430.CD65.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 10:31:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-07-08 at 20:06 +0900, KOSAKI Motohiro wrote:
> > > [ small note on that we really should kill __GFP_NOFAIL, its utter
> > > deadlock potential ]
> > 
> > I disagree. __GFP_NOFAIL mean this allocation failure can makes really
> > dangerous result. Instead, OOM-Killer should try to kill next process.
> > I think. 
> 
> Say _what_?! you think NOFAIL is a sane thing? 

insane obviously ;)
but as far as my experience, some embedded system prefer to use NOFAIL.
So, I don't like to make big hammer crash. NOFAIL killing need long year
rather than you expected, I guess.


> Pretty much everybody has
> been agreeing for years that the thing should die.

I'm not against this at all. but until it die, it should works correctly.


