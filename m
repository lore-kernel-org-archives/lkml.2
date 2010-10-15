Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0JONyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:54:54 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33133 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JONyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:54:54 -0400
Subject: Re: [PATCH] perf_events: fix bogus AMD64 generic TLB events
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <4cb85478.41e9d80a.44e2.3f00@mx.google.com>
References: <4cb85478.41e9d80a.44e2.3f00@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 15:54:34 +0200
Message-ID: <1287150874.29097.1515.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 15:15 +0200, Stephane Eranian wrote:
> PERF_COUNT_HW_CACHE_DTLB:READ:MISS had a bogus umask value of 0 which
> counts nothing. Needed to be 0x7 (to count all possibilities).
> 
> PERF_COUNT_HW_CACHE_ITLB:READ:MISS had a bogus umask value of 0 which
> counts nothing. Needed to be 0x3 (to count all possibilities).
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks! tagged it for -stable as well.
