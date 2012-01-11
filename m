Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2AKFIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 00:08:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47575 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2AKFIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 00:08:51 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au>
References: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au>
Date: Tue, 10 Jan 2012 21:08:49 -0800
Message-ID: <CAOesGMh0W1hvpySB8jtVBojZtoniHXur98Bzq1Feh3vAD4CkOg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 6:31 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Mauro,
>
> Today's linux-next merge of the v4l-dvb tree got conflicts in a large
> number of files between commits from the arm-soc tree and commits from the
> v4l-dvb tree.  You have rebased the v4l-dvb tree onto v3.2 while the
> arm-soc tree had merged a previous version. you have then added a lot
> more commits on top of the result - which produces all the conflicts.  :-(
>
> This is exactly the sort of pain I alluded to when I first noted that the
> v4l-dvb tree had been merged into the arm-soc tree ...

We do this every now and then though, it's not an issue as long as
nothing stupid is done with the dependent branch at the other end.
I.e. if it's actually a stable branch (which we got promised that it
was).

So, why was the whole v4l tree rebased? Guennadi, you said it was
going to be a stable branch? What happened?

> Not happy.

No kidding.  Mauro, can you undo your rebase or should I remove the
dependent branch (and the at91 branch that needs it) from arm-soc
instead?


-Olof
