Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1ALOHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:07:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:45696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1ALOHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:07:44 -0500
Subject: Re: Q: perf log mode?
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 12 Jan 2011 15:08:08 +0100
Message-ID: <1294841288.19601.49.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 17:06 +0300, Kirill Smelkov wrote:
> I'm trying to use perf together with e.g. kprobes as a tool to show what
> is happening with my system in "live-log" mode. The problem is, for
> seldom events, actual info output is largely delayed because perf reads
> sample data in whole pages. Could something be done with it or am I'm
> missing something? Here is detailed description: 

perf_event_attr = {
	.watermark = 0,
	.wakeup_events = 1,
};


