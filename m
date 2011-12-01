Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1LAXHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:07:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:51912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1LAXHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:07:33 -0500
Message-ID: <1322780830.4699.62.camel@twins>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Fri, 02 Dec 2011 00:07:10 +0100
In-Reply-To: <20111201221404.GC3365@kroah.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
	 <1322776568.4699.52.camel@twins> <20111201221404.GC3365@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 14:14 -0800, Greg KH wrote:
> greg k-h

Greg, why are you merging this crap anyway? Aren't there enough tracer
thingies around already?
