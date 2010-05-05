Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189Ab0EEJLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:11:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0EEJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:11:32 -0400
Subject: Re: [PATCH 03/12] perf: add perf_event_task_migrate()
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100505050846.GG5427@nowhere>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272976724-14312-4-git-send-email-tj@kernel.org>
	 <20100505050846.GG5427@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 11:11:24 +0200
Message-ID: <1273050684.1642.231.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 07:08 +0200, Frederic Weisbecker wrote:
> 
> In fact why not moving both tracing calls under this check.
> This is going to fix the migrate trace event that gets called
> even on "spurious" migrations, and you avoid the duplicate check
> in the perf callback. 

I kept the tracepoint out of that because I wanted to see how often it
attempts silly migrations :-)



