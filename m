Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab0FJLMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:12:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab0FJLKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:52 -0400
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1276166813.2077.96.camel@twins>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
	 <1276141760-11590-2-git-send-regression-fweisbec@gmail.com>
	 <1276166813.2077.96.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 13:10:42 +0200
Message-ID: <1276168242.2077.134.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 12:46 +0200, Peter Zijlstra wrote:
> 
> Something like the below would work, the only 'problem' is that it grows
> hw_perf_event.

If we do the whole PAUSEd thing right, we'd not need this I think.
