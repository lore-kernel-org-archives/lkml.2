Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1JRLBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:01:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:41651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1JRLBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:01:48 -0400
Subject: Re: [PATCH] perf: Carve out callchain functionality
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 18 Oct 2011 13:01:35 +0200
In-Reply-To: <1318778104-17152-1-git-send-email-fweisbec@gmail.com>
References: <1318778104-17152-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318935695.21167.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 17:15 +0200, Frederic Weisbecker wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Split the callchain code from the perf events core into
> a new kernel/events/callchain.c file.
> 
> This simplifies a bit the big core.c
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> [keep ctx recursion handling inline and use internal headers]
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com> 

Thanks!
