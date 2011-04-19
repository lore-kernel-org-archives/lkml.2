Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1DST5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:57:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab1DST5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:57:30 -0400
Date: Tue, 19 Apr 2011 12:55:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "azurIt" <azurit@pobox.sk>
Cc: "Eric Dumazet" <eric.dumazet@gmail.com>, "Changli Gao" <xiaosuo@gmail.com>,
        =?ISO-8859-1?Q? "Am=E9rico_Wang" ?= <xiyou.wangcong@gmail.com>,
        "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        "Jiri Slaby" <jirislaby@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: Regression from 2.6.36
Message-Id: <20110419125557.b381e097.akpm@linux-foundation.org>
In-Reply-To: <20110419212920.AFE7DD8D@pobox.sk>
References: <20110315132527.130FB80018F1@mail1005.cent>
	<20110317001519.GB18911@kroah.com>
	<20110407120112.E08DCA03@pobox.sk>
	<4D9D8FAA.9080405@suse.cz>
	<BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
	<1302177428.3357.25.camel@edumazet-laptop>
	<1302178426.3357.34.camel@edumazet-laptop>
	<BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
	<1302190586.3357.45.camel@edumazet-laptop>
	<20110412154906.70829d60.akpm@linux-foundation.org>
	<BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
	<20110412183132.a854bffc.akpm@linux-foundation.org>
	<1302662256.2811.27.camel@edumazet-laptop>
	<20110413141600.28793661.akpm@linux-foundation.org>
	<20110413142416.507e3ed0.akpm@linux-foundation.org>
	<20110419212920.AFE7DD8D@pobox.sk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 21:29:20 +0200
"azurIt" <azurit@pobox.sk> wrote:

> which kernel versions will include this patch ? Thank you.

Probably 2.6.39. If so, some later 2.6.38.x too.
