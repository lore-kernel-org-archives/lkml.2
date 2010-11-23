Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0KWUVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:21:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60004
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab0KWUVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:21:37 -0500
Date: Tue, 23 Nov 2010 12:22:03 -0800 (PST)
Message-Id: <20101123.122203.260090992.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: adilger.kernel@dilger.ca, wharms@bfs.de, xiyou.wangcong@gmail.com,
        eric.dumazet@gmail.com, segoon@openwall.com,
        kernel-janitors@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jakub@redhat.com
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101123121840.e9d17d91.akpm@linux-foundation.org>
References: <4CEBD37E.5060107@bfs.de>
	<203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca>
	<20101123121840.e9d17d91.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 23 Nov 2010 12:18:40 -0800

> We can't reasonably address this with gcc changes.  If gcc starts doing
> what we want in the next release, how long will it be until that
> release is the *oldest* version of gcc which the kernel may be compiled
> with?  Five years?

Completely agreed.
