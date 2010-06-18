Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156Ab0FRMZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:25:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45413 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab0FRMZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:25:42 -0400
Date: Fri, 18 Jun 2010 14:25:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100618122532.GB9045@basil.fritz.box>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com> <1276862130.1875.7.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276862130.1875.7.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So aside from the should this be perf or not, the above is utter
> gibberish. Whoever came up with this nonsense?

This is pretty much how softirqs (and before them bottom halves) work.
I believe Linus invented that scheme originally back in the early
days of Linux.

It's actually quite simple and works well

-Andi
