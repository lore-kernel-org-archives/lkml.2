Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2IQJNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:13:53 -0400
Received: from mail.anarazel.de ([217.115.131.40]:44197 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342Ab2IQJNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:13:52 -0400
From: Andres Freund <andres@anarazel.de>
To: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: Excessive kernel time inside ttm when scrolling on a r700 in a multimonitor setup
Date: Mon, 17 Sep 2012 11:13:44 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc4-andres-00001-ga7ab0ca; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
References: <201209170118.25955.andres@anarazel.de> <CAH3drwZ-Wc=PViwuj=PgcOrsZBfvozdZRK=Q2Q-uJFktSbGQcw@mail.gmail.com>
In-Reply-To: <CAH3drwZ-Wc=PViwuj=PgcOrsZBfvozdZRK=Q2Q-uJFktSbGQcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171113.45276.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012 10:47:10 AM Jerome Glisse wrote:
> On Sun, Sep 16, 2012 at 7:18 PM, Andres Freund <andres@anarazel.de> wrote:
> > Hi everyone,
> > 
> > In several gui programs, most notably and reproducably, I can trivially
> > make Xorg spend the whole cpu time in the kernel. It might be an Xorg
> > bug, but from my untrained gut feeling it doesn't look that way.
> > 
> > Anything more you need than whats already in the email?
> 
> > Here are some details:
> Is it an AGP card ? It looks like it's the PAT update that kills perf
> for you, not much we can do, the pool allocator is probably starve.
If you mean AGP as in the old strange graphics bus, no. Its a pcie card.

If that helps you, more detailedly the card is a: SAPPHIRE Radeon HD6870

Unfortunately the manufacturers page is remarkably devoid of details...: 
http://www.sapphiretech.com/presentation/product/?cid=1&gid=3&sgid=1037&lid=1&pid=1270&leg=0

Greetings,

Andres
