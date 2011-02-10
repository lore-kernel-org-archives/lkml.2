Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1BJDvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:51:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60918 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752761Ab1BJDvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:51:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+2RgIy3fu2zplDgXAQt+hvd1nQHDP4P9PBTXn9px
	qQr1miRRP6dcB6
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
 regression
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <1297309313.7996.11.camel@marge.simson.net>
References: <new-submission>
	 <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
	 <1297224378.8035.7.camel@marge.simson.net>
	 <20110209164154.GA15607@ghostprotocols.net>
	 <1297309313.7996.11.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 04:51:31 +0100
Message-ID: <1297309891.7996.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 04:41 +0100, Mike Galbraith wrote:

> I like this a lot, great for live rummaging.   One thing that would help
> with large files maybe - a jump to next spot hotter than N%, but as is

(and callgraphs, and a snapshot logger with notes insertion and and...
boy, tui thingy adds a _lot_ of potential to top:) 

