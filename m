Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1DGP0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:26:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1DGP0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:26:17 -0400
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D9DD62E.2050308@zytor.com>
References: <4D9CE4AE.4090303@zytor.com> <1302185312.3329.1240.camel@twins>
	 <4D9DCDAB.9000707@zytor.com> <1302188050.9086.27.camel@twins>
	 <4D9DD08C.2080101@zytor.com> <1302188635.9086.44.camel@twins>
	 <4D9DD62E.2050308@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Apr 2011 17:26:05 +0200
Message-ID: <1302189965.9086.71.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 08:20 -0700, H. Peter Anvin wrote:
> 
> OK, this doesn't really need any hooks at all (the tip-bot is not a
> hook).  The committer is, and *has to be* responsible for getting the
> unique string into the Link: tag, through whatever means they feel is
> appropriate.
> 
> Based on the previous message, I'm going to modify the bot to
> recognize
> the pattern:
> 
> Link: http://lkml.kernel.org/r/tip-`ranpwd -l 24`@git.kernel.org
> 
> ... to override the Message-ID.  It seems like the least ugly of a lot
> of ugly options. 

OK, but to qualify, it needn't be the committer, that is, Ingo usually
commits the stuff for me, but I usually provide him with complete
patches including LKML-Reference, now Link, tag.

I'll change my script to:

Use an existing Link tag provided it doesn't match the above pattern, if
there's no such tag, use Message-id, lacking that, generate one using
the above pattern.

Thanks!
