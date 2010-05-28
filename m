Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0E1Hjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:39:37 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:56017 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0E1Hjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:39:35 -0400
Message-ID: <4BFF7331.9080806@bfs.de>
Date: Fri, 28 May 2010 09:39:29 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Wolfram Sang <w.sang@pengutronix.de>, Joerg Roedel <joro@8bytes.org>,
       Nicolas Palix <npalix@diku.dk>, Randy Dunlap <rdunlap@xenotime.net>,
       Roland Dreier <rdreier@cisco.com>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Gilles Muller <Gilles.Muller@lip6.fr>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk, Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add a Coccinelle front-end script
References: <1273508667-5152-1-git-send-email-npalix@diku.dk> <20100528070921.GK1237@8bytes.org> <20100528072504.GB3344@pengutronix.de> <Pine.LNX.4.64.1005280931230.9138@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005280931230.9138@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> On Fri, 28 May 2010, Wolfram Sang wrote:
> 
>>> Don't know how complex the coccinelle software itself is, but I think it
>>> would make sense to ship it with the kernel-sources too. That together
>> You can easily find out by browsing the homepage of coccinelle.
> 
> Over 100 000 lines of code.
> 
> julia
> --

coccinelle is a great programm and should have its own repository.
I don not thing thats a clever idea to integrate it directly into
the kernel source tree. IMHO it would hinder the development of coccinelle
in the long term.

re,
 wh




