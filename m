Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1GQKru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 06:47:50 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58096 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab1GQKrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 06:47:49 -0400
Date: Sun, 17 Jul 2011 12:47:34 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Witten <mfwitten@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: Large Patch Series in Email         (was Re: [PATCH 0000/0117]
 Staging: hv: Driver cleanup)
Message-ID: <20110717124734.3a28aead@schatten.dmk.lab>
In-Reply-To: <20110716000739.3239bac8@lxorguk.ukuu.org.uk>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
	<84fa825a57d34571a5aa66ae7299461c-mfwitten@gmail.com>
	<20110716000739.3239bac8@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jul 2011 00:07:39 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >   Do not send more than 15 patches at once to the vger
> >   mailing lists!!!
> > 
> > and, accordingly, I went to the trouble of setting up a GitHub
> > account to host a repo from which I could issue *one* single
> > PULL request email; I get a little miffed every time my
> > inbox gets blasted with hundreds of patches when others don't
> > do similarly.
> 
> The problem with dumping stuff that needs review into a git tree is it's
> a lot of hassle to review so the advice is kind of outdated in such cases.
> It's good advice for things like big new subsystems perhaps but not for
> review.
> 
> As is always the case social norms evolve faster than the people who feel
> compelled to attempt to document them.
> 
> There are lots of web archives of the list and it's also not hard to set
> up mail tools to shuffle long emails into a folder so there are plenty of
> ways to manage and read the lists without being part of it.
> 
> And someone should probably updating the CodingStyle document to reflect
> reality 8)
> 
> Alan

And while at it, maybe add some tipps on how to keep patchseries
small... (people have probably more / better suggestions, please):

- 'submit early, submit often' instead of time based submittal (like...
  oh I hacked 24/7 this week and now is friday, let's see how many
  patches I got...)
- Putting controversial stuff at the end (so at least uncontroversial
  stuff can be applied)
- try to split patchseries into stuff that can be applied independent
  of one another. 
- ...

Regards,
Flo
