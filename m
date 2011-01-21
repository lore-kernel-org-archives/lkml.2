Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1AUPqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:46:50 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34329 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1AUPqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:46:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71393856"
Subject: Re: [PATCH 0/7] Nexus One Support
From: Daniel Walker <dwalker@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Dima Zavin <dmitriyz@google.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org
In-Reply-To: <1295576730.4096.24.camel@Joe-Laptop>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	 <1295571359.9236.53.camel@m0nster>  <1295574085.4096.6.camel@Joe-Laptop>
	 <1295575123.9236.54.camel@m0nster>  <1295576730.4096.24.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 07:46:41 -0800
Message-ID: <1295624801.19880.13.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 18:25 -0800, Joe Perches wrote:
> On Thu, 2011-01-20 at 17:58 -0800, Daniel Walker wrote:
> > On Thu, 2011-01-20 at 17:41 -0800, Joe Perches wrote:
> > > On Thu, 2011-01-20 at 16:55 -0800, Daniel Walker wrote:
> > > > On Thu, 2011-01-20 at 16:42 -0800, Dima Zavin wrote:
> > > > > You are not the author of any of these patches. Where are the author
> > > > > attributions for the team that actually wrote this code?
> > > > In the commit text.. The author field is used to denote who authored the
> > > > commit, which in this case is me.
> > > You have that wrong.
> > > Author and Committer are different git fields.
> > > http://www.kernel.org/pub/software/scm/git/docs/user-manual.html
> > > 
> > >       * an author: The name of the person responsible for this change,
> > >         together with its date.
> > >       * a committer: The name of the person who actually created the
> > >         commit, with the date it was done. This may be different from
> > >         the author, for example, if the author was someone who wrote a
> > >         patch and emailed it to the person who used it to create the
> > >         commit.
> > I'm not even sure how to make these different, but in this case it
> > doesn't matter because the "committer" as you defined it above is more
> > than one person ..
> 
> Not really, no.
> 
> The authors may be different, but the first git
> committer of the patch is different.
> 
> The committer is the person that does a git commit
> either directly with git commit or git am.
> 
> If a git tree is pulled by someone else, the initial
> committer name remains on the commit.
> 
> You should keep the original patch author names and
> add your own "Signed-off-by:" and not claim authorship
> of the patches themselves.

This isn't what's happening tho. In maintainer land if someone forwards
you a patch then you leave the original author on the patch. They wrote
the patch and your just forwarding it on up the ladder. This isn't the
case with these patches.. I crafted each of the commit I have authorship
on, no one forwarded those commits to me. I'm not taking authorship
credit for any thing I didn't create, although I an giving credit to the
place which gave me the raw material which was Google. From my
experience this is how it's done in Linux ..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


