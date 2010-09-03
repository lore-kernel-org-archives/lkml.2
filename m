Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0ICCkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:40:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45135 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0ICCkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:40:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 1/2] Add trace points to mmap, munmap, and brk
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        mingo@redhat.com, hugh.dickins@tiscali.co.uk, riel@redhat.com,
        peterz@infradead.org, anton@samba.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1283435985-21934-2-git-send-email-emunson@mgebm.net>
References: <1283435985-21934-1-git-send-email-emunson@mgebm.net> <1283435985-21934-2-git-send-email-emunson@mgebm.net>
Message-Id: <20100903113904.B665.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Sep 2010 11:40:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds trace points to mmap, munmap, and brk that will report
> relevant addresses and sizes before each function exits successfully.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>

These tracepoint are still poor than syscall trace. I don't think this is
good idea. Please avoid fixed specific tracepoint. Please consider make generic.




