Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2GKCpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 22:45:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35398 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2GKCpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 22:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120709141225.GA17314@barrios>
References: <1341801500-5798-1-git-send-email-minchan@kernel.org>
	<20120709082200.GX14154@suse.de>
	<20120709084657.GA7915@bbox>
	<jtek81$ja5$1@dough.gmane.org>
	<20120709141225.GA17314@barrios>
Date: Wed, 11 Jul 2012 10:45:31 +0800
Message-ID: <CAM_iQpWbPywocE+phUTbp+DJrZdFEM_Y85Lj37_Tdzj976CaTw@mail.gmail.com>
Subject: Re: [PATCH] mm: Warn about costly page allocation
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 10:12 PM, Minchan Kim <minchan@kernel.org> wrote:
>
> Embedded can use CONFIG_PRINTK and !CONFIG_BUG for size optimization
> and printk(pr_xxx) + dump_stack is common technic used in all over kernel
> sources. Do you have any reason you don't like it?
>

No, I am just feeling like it is a kind of dup. No objections from me.

Thanks.
