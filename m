Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577Ab2C3WAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:00:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965386Ab2C3WAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:00:36 -0400
Date: Fri, 30 Mar 2012 19:00:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] perf tools: fix build for rbtree.c change
Message-ID: <20120330220030.GK18888@infradead.org>
References: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
 <CA+5PVA6h3+493VrZg1OyjkjP9f77CLC9PP9PuJOGMYNLM9Lq4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6h3+493VrZg1OyjkjP9f77CLC9PP9PuJOGMYNLM9Lq4w@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 30, 2012 at 01:47:53PM -0400, Josh Boyer escreveu:
> On Fri, Mar 30, 2012 at 1:38 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > rbtree.c in the main tree now includes linux/export.h, so this file
> > needs a stub too. This makes perf build again in mainline.
> >
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=2c86bf172e550b4bf089ac7f0de3f6370e243842
> 
> Apparently 'perf-urgent-for-linus' isn't as urgent as it sounds?

There was a delay due to a resolution on getting rid of pre-generated
bison/flex files, but Ingo should expedite that pull request RSN.

- Arnaldo
