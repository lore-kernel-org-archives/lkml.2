Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab0DHVYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:24:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:36770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab0DHVYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:24:23 -0400
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
 perf_prepare_sample()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <w2ibd4cb8901004081418zf82adbfcu21316a5c8483b755@mail.gmail.com>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop> <1270760599.20295.3144.camel@laptop>
	 <w2ibd4cb8901004081418zf82adbfcu21316a5c8483b755@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 23:24:20 +0200
Message-ID: <1270761860.20295.3162.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:18 +0200, Stephane Eranian wrote:
> I am not sure I understand what you mean by buffered PEBS. Are you talking
> about using PEBS buffer bigger than one entry?

Yep.

> If so, how can you do:
>   - the LBR based fixups for multiple samples (on PMU interrupt)

Not, so it would be the offset on.

>   - attribute PID/TID in system-wide mode

flush on context switches.

