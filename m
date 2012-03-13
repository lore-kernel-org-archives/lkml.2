Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab2CMII7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:08:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44120 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab2CMII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:08:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAFPAmTSR_Lvsi2+Uid3a9RQK5bBnN3vD_cje6o02f-gBusCJHQ@mail.gmail.com>
References: <20120313024818.GA7125@barrios>
	<1331620214-4893-1-git-send-email-wenqing.lz@taobao.com>
	<20120313064832.GA4968@gmail.com>
	<4F5EF563.5000700@openvz.org>
	<CAFPAmTTPxGzrZrW+FR4B_MYDB372HyzdnioO0=CRwx0zQueRSQ@mail.gmail.com>
	<CAFPAmTS-ExDtS7rpJoygc6MCwC10spapyThq7=5cCCGFbjZtqA@mail.gmail.com>
	<20120313080535.GA5243@gmail.com>
	<CAFPAmTSR_Lvsi2+Uid3a9RQK5bBnN3vD_cje6o02f-gBusCJHQ@mail.gmail.com>
Date: Tue, 13 Mar 2012 13:38:56 +0530
Message-ID: <CAFPAmTQWsq5sjnTVYL5ark6=LSOmOwiRsCr7wqTp=4ymBAUdUQ@mail.gmail.com>
Subject: Re: Fwd: Control page reclaim granularity
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Kautuk Consul <consul.kautuk@gmail.com>, minchan@kernel.org,
        riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        Zheng Liu <wenqing.lz@taobao.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I agree, but that's not my point.
>
> All I'm saying is that we probably don't want to give normal
> unprivileged usermode apps
> the capability to set the mapping to AS_UNEVICTABLE as anyone can then
> write an application
> that hogs memory without allowing the kernel to free it through memory reclaim.

Sorry, I mean :
"... that hogs kernel unmapped page-cache memory without allowing the
kernel to free it through memory reclaim."
