Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0HXHPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:15:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38168 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0HXHO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:14:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Aug 2010 16:09:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 1/6] mm: strictly nested kmap_atomic
Message-Id: <20100824160948.4923ff0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100819202753.595997973@chello.nl>
References: <20100819201317.673172547@chello.nl>
	<20100819202753.595997973@chello.nl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 22:13:18 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Ensure kmap_atomic usage is strictly nested
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

