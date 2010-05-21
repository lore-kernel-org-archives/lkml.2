Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0EUBMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:12:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38186 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0EUBMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:12:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zan Lynx <zlynx@acm.org>
Subject: Re: RFC: dirty_ratio back to 40%
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>
In-Reply-To: <4BF5D875.3030900@acm.org>
References: <20100521083408.1E36.A69D9226@jp.fujitsu.com> <4BF5D875.3030900@acm.org>
Message-Id: <20100521100943.1E4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 21 May 2010 10:11:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So, I'd prefer to restore the default rather than both Redhat and SUSE apply exactly
> > same distro specific patch. because we can easily imazine other users will face the same
> > issue in the future.
> 
> On desktop systems the low dirty limits help maintain interactive feel. 
> Users expect applications that are saving data to be slow. They do not 
> like it when every application in the system randomly comes to a halt 
> because of one program stuffing data up to the dirty limit.

really?
Do you mean our per-task dirty limit wouldn't works?

If so, I think we need fix it. IOW sane per-task dirty limitation seems independent issue 
from per-system dirty limit.


> The cause and effect for the system slowdown is clear when the dirty 
> limit is low. "I saved data and now the system is slow until it is 
> done." When the dirty page ratio is very high, the cause and effect is 
> disconnected. "I was just web surfing and the system came to a halt."
> 
> I think we should expect server admins to do more tuning than desktop 
> users, so the default limits should stay low in my opinion.


