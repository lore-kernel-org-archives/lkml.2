Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0IJVj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 17:39:56 -0400
Received: from ist.d-labs.de ([213.239.218.44]:34741 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab0IJVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 17:39:55 -0400
Date: Fri, 10 Sep 2010 23:39:52 +0200
From: Florian Mickler <florian@mickler.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910233952.5a769a79@schatten.dmk.lab>
In-Reply-To: <20100910140404.372bac58.akpm@linux-foundation.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910123040.5a6f0128@schatten.dmk.lab>
	<20100910140404.372bac58.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 14:04:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 10 Sep 2010 12:30:40 +0200
> Florian Mickler <florian@mickler.org> wrote:
> 
> > People that get angered by being cc'd a lot as commit_signers can always
> > filter their mail for that. 
> 
> People who get angry at an unexpected cc need to get a clue.  Or
> get slapped.
> 
> I mean really, it's not a big deal.  And the addition of the occasional
> inappropriate cc is a far less serious problem than the omission of
> someone who might have been interested in the change.

Indeed. So what is your opinion on the patch? 
In my opinion it is a net win, because realistically we can not go
around and slap them... can we? 

So this change might enable those who really have a problem with it, to
filter for it. 
Anybody who cares on the sending side, can edit it out, or perhaps,
when we make it optional, opt out of it. 

I personally would like such annotations on the sending side, because I
don't wanna anger people, and would perhaps when in doubt, trim the cc
list. But the annotation enables me to say: Hey, it was an
automatic cc'list. So you could have filtered it out. Don't be angry
with me! 

While on the receiving side, I might prioritize mails I get as an
maintainer (not that I am a maintainer.. but..), while other mail goes
to the read-on-a-rainy-day-mailbox. 

Cheers,
Flo

