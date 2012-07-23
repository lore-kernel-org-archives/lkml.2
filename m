Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2GWXTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:19:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2GWXT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:19:28 -0400
Date: Mon, 23 Jul 2012 16:19:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        stable@vger.kernel.org
Subject: Re: [PATCH for-3.5 1/4] kdb: Revive dmesg command
Message-Id: <20120723161927.9af62e29.akpm@linux-foundation.org>
In-Reply-To: <20120721002737.GA2213@lizard>
References: <20120721002529.GA20567@lizard>
	<20120721002737.GA2213@lizard>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012 17:27:37 -0700
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> dmesg command appears to be broken after the printk rework. The old logic
> in kdb code makes no sense in terms of current printk/logging storage
> format, and KDB simply hangs forever.
> 
> This patch revives the command by switching to kmsg_dumper iterator.
> 
> The code is now much more simpler and shorter.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

This one should me merged into 3.5.1 methinks.  Note that it has been
merged into mainline without a -stable tag.

