Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1CaAw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:52:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34494 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1CaAw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:52:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110330233050.GG21838@one.firstfloor.org>
References: <20110330144507.2c0ecf73.akpm@linux-foundation.org> <20110330233050.GG21838@one.firstfloor.org>
Message-Id: <20110331095251.0EC3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 31 Mar 2011 09:52:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do we still want it?  Are we sure we don't want the per-zone numbers?
> 
> At least I still want it and Dave Hansen did too.
> 
> I don't need per zone personally and I remember a strong request from 
> anyone.  Or was there one?

If my remember is correct, Only /me puted weak request of per-zone number.
To be honest, myself never use this counter, my question was just curious.
Then, I'm ok if Andi didn't hit any issue.

Andi, But, if anyone will put numa request or numa related bug report 
in future, Perhaps I might convert it per-zone one. Is this ok?



