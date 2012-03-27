Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2C0WLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:11:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59539 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab2C0WLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:11:12 -0400
Date: Wed, 28 Mar 2012 02:11:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, p4: Add format attributes
Message-ID: <20120327221107.GA9669@moon>
References: <1332859842.16159.227.camel@twins>
 <20120327145728.GE11875@moon>
 <1332860759.16159.233.camel@twins>
 <20120327151250.GG11875@moon>
 <20120327220343.GG16537@moon>
 <1332885905.2528.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332885905.2528.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:05:05AM +0200, Peter Zijlstra wrote:
> 
> So does that make escr:32-62 or should that become 32-63 ?

32-63 I think will be better, because it's raw format for
escr, simply 63 bit is never used in hw level so we borrowed
it for own needs.

	Cyrill
