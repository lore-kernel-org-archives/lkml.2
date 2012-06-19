Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2FSLer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:34:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:37324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2FSLep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:34:45 -0400
Date: Tue, 19 Jun 2012 08:34:34 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Cromie <jim.cromie@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] perf stat: Fix default logfd to use stderr
Message-ID: <20120619113434.GB6560@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
 <1317336490-19437-8-git-send-email-acme@infradead.org>
 <20120618145108.GG5046@erda.amd.com>
 <87zk80giag.fsf@sejong.aot.lge.com>
 <CABPqkBQA+CDxzp_g2Lu=Uoet5oqOq5E_1eiATGfoX=d7xEO49g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQA+CDxzp_g2Lu=Uoet5oqOq5E_1eiATGfoX=d7xEO49g@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 19, 2012 at 08:09:31AM +0200, Stephane Eranian escreveu:
> On Tue, Jun 19, 2012 at 4:13 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> > On Mon, 18 Jun 2012 16:51:08 +0200, Robert Richter wrote:
> >> With certain shell redirections this (56f3bae) fails with a log fd
> >> setup failure. Fix below.

> > It looks somewhat related to Stephane's patch. Can you we check it too?

> > http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/04232.html

> Yes, my patch is needed and it was posted over a month ago now.....
> Arnaldo, please apply my patch.

It was applied a week ago, was merged already by Ingo, should go to
Linus soon:

http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=fc3e4d077d5c7a7bc1ad5bc143895b4e070e5a8b

- Arnaldo
