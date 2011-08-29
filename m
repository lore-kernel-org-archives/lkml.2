Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1H2WGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:06:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44039 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab1H2WGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:06:01 -0400
Date: Mon, 29 Aug 2011 18:03:48 -0400 (EDT)
Message-Id: <20110829.180348.1774953636752413432.davem@davemloft.net>
To: bharrosh@panasas.com
Cc: Trond.Myklebust@netapp.com, joe@perches.com, bfields@fieldses.org,
        neilb@suse.de, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/24] sunrpc: Remove unnecessary OOM logging messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E5C0AB3.90401@panasas.com>
References: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430AEB4EE9@SACMVEXC2-PRD.hq.netapp.com>
	<20110829.143751.1153162956919885670.davem@davemloft.net>
	<4E5C0AB3.90401@panasas.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 29 Aug 2011 15:03:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 29 Aug 2011 14:54:59 -0700

> I have a question about that. Are the dprints going to show the stack backtrace?

Yes, OOMs give full stack backtraces.

> If yes above? then I'm not sure I like it either, because am I'll be getting a full
> stack backtrace for every failed allocation?

They've been doing this for years, so obviously they haven't bothered you
enough to care up to this point.

All of this pushback is pure uneducated noise, please stop blocking progress
with poorly informed objections.
