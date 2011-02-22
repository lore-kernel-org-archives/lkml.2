Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1BVPnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:43:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:60423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab1BVPnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:43:49 -0500
Subject: Re: [PATCH] perf lock: clean the options for perf record
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4D63D685.2010401@dcl.info.waseda.ac.jp>
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <4D63D685.2010401@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Feb 2011 16:43:35 +0100
Message-ID: <1298389415.2217.243.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 00:30 +0900, Hitoshi Mitake wrote:
> How do you think about it?

Most of the lock code (esp the spinlock stuff) is already way over the
threshold of sanity, adding to that for some dubious reasons doesn't
seem like a good idea.

I'm still not at all sure why people want all this lock tracing.
