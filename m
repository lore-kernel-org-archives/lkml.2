Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531Ab0HFPkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:40:32 -0400
Received: from mail.perches.com ([173.55.12.10]:2313 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab0HFPk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:40:29 -0400
Subject: Re: [PATCH 05/10] perf hists: Fixup addr snprintf width on 32 bit
 arches
From: Joe Perches <joe@perches.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1281108932.17033.27.camel@Joe-Laptop.home>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
	 <1281059177-18747-6-git-send-email-acme@infradead.org>
	 <1281059887.19943.23.camel@Joe-Laptop.home>
	 <20100806142945.GC17509@ghostprotocols.net>
	 <1281108932.17033.27.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 08:40:26 -0700
Message-ID: <1281109226.17033.30.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 08:35 -0700, Joe Perches wrote:
> snprintf(loc, size, "%p", (void)long)
> might be best.

Oops.

On the other hand, "%p", (void *) would compile
without warnings and be what I meant in the first
place...

snprintf(loc, size, "%p", (void *)long)


