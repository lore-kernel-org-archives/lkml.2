Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0F2Qky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:40:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:56863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab0F2Qkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:40:52 -0400
Subject: Re: [RFC][PATCH 11/11] perf: Rework the PMU methods
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100629153753.GI5318@nowhere>
References: <20100624142804.431553874@chello.nl>
	 <20100624143407.106583261@chello.nl>  <20100629153753.GI5318@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 18:40:01 +0200
Message-ID: <1277829601.1868.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 17:37 +0200, Frederic Weisbecker wrote:

> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

I know it breaks at least x86 (although subtle, takes a few perf records
to daze and confuse), arm and sh.

I need to get back to this patch-set and sort that :-)
