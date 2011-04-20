Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1DTAdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:33:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35411 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1DTAdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:33:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH followup] mm: get rid of CONFIG_STACK_GROWSUP || CONFIG_IA64
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110419110956.GD21689@tiehlicka.suse.cz>
References: <20110419091022.GA21689@tiehlicka.suse.cz> <20110419110956.GD21689@tiehlicka.suse.cz>
Message-Id: <20110420093326.45EF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 09:33:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While I am in the cleanup mode. We should use VM_GROWSUP rather than
> tricky CONFIG_STACK_GROWSUP||CONFIG_IA64.
> 
> What do you think?

Now, VM_GROWSUP share the same value with VM_NOHUGEPAGE.
(this trick use the fact that thp don't support any stack growup architecture)

So, No.
Sorry for that.




