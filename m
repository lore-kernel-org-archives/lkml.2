Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab1BIEGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 23:06:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45142 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756290Ab1BIEGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 23:06:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ZCfNwy3aZveOm6Bw1g5TFJrUvX5/1fyJ6bJi+oh
	igKKk6sYZSHqoT
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
 regression
From: Mike Galbraith <efault@gmx.de>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
References: <new-submission>
	 <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 05:06:18 +0100
Message-ID: <1297224378.8035.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 00:43 +0000, tip-bot for Arnaldo Carvalho de Melo
wrote:
> Commit-ID:  d5e3d747007fdb541e57ed72e020ff0b94db3470
> Gitweb:     http://git.kernel.org/tip/d5e3d747007fdb541e57ed72e020ff0b94db3470
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Tue, 8 Feb 2011 15:29:25 -0200
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Tue, 8 Feb 2011 15:29:25 -0200
> 
> perf annotate: Fix annotate context lines regression
> 
> The live annotation done in 'perf top' needs to limit the context before
> lines that aren't filtered out by the min percent filter, if we don't do
> that, the screen in a tty often is not enough for showing what is
> interesting: lines with hits and a few source code lines before it.

Looks to me like this went from regress a bit while waiting for tui
thing to progress a bit immediately :)

	-Mike

