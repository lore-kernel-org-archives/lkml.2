Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0DNQAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:00:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab0DNQAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:00:17 -0400
Date: Wed, 14 Apr 2010 18:00:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] tracing: lost events changes
Message-ID: <20100414160005.GA26429@elte.hu>
References: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
 <1271257888.19099.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271257888.19099.4.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-04-14 at 15:00 +0200, Jiri Olsa wrote:
> > hi,
> > 
> > I noticed LOST EVENTS messages in the iterator "trace" file.
> > According to the comment from commit bc21b478 this won't work.
> > 
> > <comment>
> >     Note, it does not work with the iterator "trace" file, since it requires
> >     the use of consuming the page from the ring buffer to determine how many
> >     events were lost, which the iterator does not do.
> > </comment>
> > 
> > I'm not sure the attached fix (2/2) is on the right place,
> > but stops the LOST EVENTS display for iterator "trace" file.
> > 
> 
> This has already been fixed by Lai:
> 
> http://marc.info/?l=linux-kernel&m=127045871922996
> 
> And I asked Ingo to pull it here:
> 
> http://marc.info/?l=linux-kernel&m=127048065715829

Yeah - i pulled it earlier today and pushed it out about two hours ago.

	Ingo
