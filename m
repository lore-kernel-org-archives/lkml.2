Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0INHyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:54:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab0INHyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:54:21 -0400
Subject: Re: [GIT PULL 0/1] perf/core ui browser improvement
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20100913212951.GI31907@ghostprotocols.net>
References: <1284395692-11298-1-git-send-email-acme@infradead.org>
	 <20100913174845.GC18428@elte.hu>
	 <20100913190758.GB31907@ghostprotocols.net> <20100913204217.GA2505@elte.hu>
	 <20100913212951.GI31907@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Sep 2010 09:54:12 +0200
Message-ID: <1284450852.2275.458.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 18:29 -0300, Arnaldo Carvalho de Melo wrote:
> +      3.00%         find  [kernel.kallsyms]   [k] n_tty_write

> +      3.00%         find  kernel       k n_tty_write

I find that [k] is visually easier to separate from the symbol name.
