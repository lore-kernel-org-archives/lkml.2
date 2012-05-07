Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2EGNFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:05:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:57548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab2EGNFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:05:12 -0400
Subject: Re: [PATCH 5/7] perf, tools: Add raw event support for dynamic
 allocated pmus
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1335983192-23731-6-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-6-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 15:05:00 +0200
Message-ID: <1336395900.27020.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:
> This patch extends the event parser to pass raw config values to a
> dynamic allocated pmu. The following event syntax is supported now:
> 
>  <pmu_name>:<raw_config_value>:<modifier>
> 
> Example for the ibs pmu:
> 
>  # perf record -a -e ibs_op:r000 ...

Yeah, clearly not going to happen...

If you'd used the existing stuff you would have been able to do:

ibs_ops/field=0x000/



