Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab2C0PHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:07:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60672 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2C0PHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:07:41 -0400
Message-ID: <1332860852.16159.234.camel@twins>
Subject: Re: [PATCH] perf, p4: Add format attributes
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 27 Mar 2012 17:07:32 +0200
In-Reply-To: <1332860759.16159.233.camel@twins>
References: <1332859842.16159.227.camel@twins> <20120327145728.GE11875@moon>
	 <1332860759.16159.233.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 17:05 +0200, Peter Zijlstra wrote:
> perf stat -e cpu/cccr=0x1234,escr=0x4321,ht/
> 
> and it would construct the perf_event_attr::config value 0x92344321
> for
> you. 

Or rather, 0xc3211234, I got cccr and escr reversed.
