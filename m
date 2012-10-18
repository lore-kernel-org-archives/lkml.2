Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2JRCP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:15:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45604 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2JRCPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:15:24 -0400
Date: Wed, 17 Oct 2012 22:15:20 -0400 (EDT)
Message-Id: <20121017.221520.1180149443190452733.davem@davemloft.net>
To: namhyung@kernel.org
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        acme@redhat.com
Subject: Re: [PATCH 10/11] perf tools: Fix build on sparc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <87txts1rtm.fsf@sejong.aot.lge.com>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
	<1350494387-10987-11-git-send-email-acme@infradead.org>
	<87txts1rtm.fsf@sejong.aot.lge.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 18 Oct 2012 10:39:49 +0900

> On Wed, 17 Oct 2012 14:19:46 -0300, Arnaldo Carvalho de Melo wrote:
>> From: David Miller <davem@davemloft.net>
>>
>> More UAPI stuff.
> 
> What about other architectures?  Don't they have the same problem?

If they took in the per-architecture UAPI pull from David Howells,
then yes.  But I don't think  all of them have, and if that's true
then just blinding converting all of them is the wrong thing to do.
