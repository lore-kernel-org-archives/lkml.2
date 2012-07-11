Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2GKPRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:17:38 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41713 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2GKPRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:17:36 -0400
Date: Wed, 11 Jul 2012 17:17:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] trace: add ability to set a target task for events (v2)
Message-ID: <20120711151728.GE17991@somewhere>
References: <1342016098-213063-1-git-send-email-avagin@openvz.org>
 <20120711143121.GA17991@somewhere>
 <1342017221.3462.159.camel@twins>
 <20120711143656.GB17991@somewhere>
 <1342017499.3462.160.camel@twins>
 <20120711144840.GC17991@somewhere>
 <1342018508.3462.163.camel@twins>
 <1342019524.3462.167.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342019524.3462.167.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 05:12:04PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-07-11 at 16:55 +0200, Peter Zijlstra wrote:
> > Right.. back when I did that the plan was to make PERF_SAMPLE_PERIOD fix
> > that, of course that never seemed to have happened.
> > 
> > With PERF_SAMPLE_PERIOD you can simply write the 1b into the period of 1
> > event and be done with it. 
> 
> It did! Andrew fixed it..

Ah! Then may be we need to force PERF_SAMPLE_PERIOD on tracepoints from
perf tools. I need to check that.
