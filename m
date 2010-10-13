Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0JMHXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:23:25 -0400
Received: from canuck.infradead.org ([134.117.69.58]:39428 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0JMHXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:23:24 -0400
Subject: Re: [RFC PATCH 4/9] perf: Don't record frame pointer based user
 stacktraces if we dump stack and regs
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286946421-32202-5-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	 <1286946421-32202-5-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Oct 2010 09:23:06 +0200
Message-ID: <1286954586.29097.60.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> User and kernel stack might be selected for other uses than callchain
> in the future, this probably shouldn't mess with the regular callchain
> code. Instead we should probably have an exclude_callchain_user
> attribute, that could be also useful to filter out user callchains
> when people don't want them. 

Probably ;-)
