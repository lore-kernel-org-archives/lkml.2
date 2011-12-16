Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab1LPO7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:59:31 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804Ab1LPO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:59:25 -0500
Subject: Re: [PATCH] lockdep: do not disable on OOT taint
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1324047469.3429.7.camel@jlt3.sipsolutions.net>
References: <1324047469.3429.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 15:59:22 +0100
Message-ID: <1324047562.3429.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 15:57 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no reason to disable lockdep due to
> out-of-tree taint since you can just ignore
> lockdep reports with OOT taint if you like
> but for people who develop out of tree it's
> still useful to have lockdep available.

Never mind. It was just pointed out to me that this was already done:

https://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=9ec84acee1e221d99dc33237bff5e82839d10cc0;hp=81140acc66322dcde8346dabdf1ab4c229fce8d4

Sorry!

johannes

