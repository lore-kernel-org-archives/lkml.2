Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2C0O5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:57:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36467 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2C0O5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:57:33 -0400
Date: Tue, 27 Mar 2012 18:57:28 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, p4: Add format attributes
Message-ID: <20120327145728.GE11875@moon>
References: <1332859842.16159.227.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332859842.16159.227.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 04:50:42PM +0200, Peter Zijlstra wrote:
> Subject: perf, p4: Add format attributes
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Mar 27 16:19:25 CEST 2012
> 
> Steven reported his P4 not booting properly, the missing format
> attributes cause a NULL ptr deref. Cure this by adding the missing
> format specification.
> 
> I took the format description out of the comment near 
> p4_config_pack*() and hope that comment is still relatively 
> accurate.
> 
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Lin Ming <ming.m.lin@intel.com>
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Tested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks a lot, Peter! This format description is somewhat
new to me (I think I've missed when it was introduced first
time).

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

	Cyrill
