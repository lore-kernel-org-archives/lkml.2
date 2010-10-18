Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab0JRUsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:48:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0JRUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:48:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Walker <dwalker@fifo99.com>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Date: Mon, 18 Oct 2010 22:48:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-next-20101015+; KDE/4.5.1; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au> <201010182219.25890.arnd@arndb.de> <1287434251.5588.23.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1287434251.5588.23.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010182248.36078.arnd@arndb.de>
X-Provags-ID: V02:K0:g09Gm4s46xL+tsqRezm5VpW6YmBwOevDoysERbMBQiI
 382BUsYGWeAnA2/y+z78DAeK8Ig/5gGx0GTvaQn4MxGBqm0g4/
 udScW8j0mygBoQrtu3LGLiXDTgAesFod0WV5aC4RN2UfNzXU8G
 S9P1cKruBmpwcIcIS8e+VY9obw/JyE4UjJx2Z1B1cW5UKlp1+R
 n2UMXbcKR4vNLtntpIApQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 October 2010 22:37:31 Daniel Walker wrote:
> > When you know that Russell does not rebase his tree, you can pull his
> > tree into yours whenever a change hits his tree that impacts you in
> > a major way. You shouldn't do this too frequently, but it's a good way
> > to resolve conflicts like this one.
> 
> If I did that all of Russell's changesets would get mixed with mine when
> I send the pull request .. That would just create confusion .. It's OK
> if Russell sends my commits to Linus, but I'm not going to send
> Russell's commits.

Actually both are ok, as long as you as the sub-maintainer send your
pull request after Russell's tree has been merged and you don't
ask anyone else to pull your tree who has not pulled Russell's tree
explicitly or implicitly through Linus.

git-request-pull is smart enough to list only the changesets that
are not in the upstream tree, as will git "log your-branch...upstream"
or "git diff your-branch upstream".

The other option you have is to ask Russell to pull your tree
at an early enough time, which also works if you did the occasional
pull from him before that.

	Arnd
