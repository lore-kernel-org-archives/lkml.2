Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647Ab2FAMsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:48:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46804 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2FAMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:48:16 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338553486.2708.25.camel@menhir>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 14:48:10 +0200
Message-ID: <1338554890.2760.1517.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 13:24 +0100, Steven Whitehouse wrote:

> Yes, you are right that it will be slow, still. But I'm not sure what we
> can do about that. We have to find our place again on each read call, in
> any case I think.

You dont really answer my question, I asked the exact timing...

I can't reproduce this slow behavior you have, using /proc/net seq
files.

Isn't it a problem with this particular file ?

Does it want to output a single record ( m->op->show(m, p) ) much larger
than 4KB ?



