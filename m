Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0GZXwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 19:52:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411Ab0GZXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 19:52:46 -0400
Date: Mon, 26 Jul 2010 16:52:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] V7: Add support for non-PDP11 v7 filesystems
Message-Id: <20100726165231.ea38062e.akpm@linux-foundation.org>
In-Reply-To: <1280098756-26522-1-git-send-email-lkundrak@v3.sk>
References: <20100724135128.GA11645@ZenIV.linux.org.uk>
	<1280098756-26522-1-git-send-email-lkundrak@v3.sk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 00:59:16 +0200
Lubomir Rintel <lkundrak@v3.sk> wrote:

> This adds byte order autodetection (of PDP-11 and LE filesystems).
> No attempt is made to detect big-endian filesystems -- were there any?
> Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.

Which kernel is this against?  My v7_fill_super() is significantly
different from yours.

