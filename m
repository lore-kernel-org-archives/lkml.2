Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2FEWR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:17:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2FEWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:17:56 -0400
Date: Tue, 5 Jun 2012 15:17:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
Message-Id: <20120605151754.a794ac7c.akpm@linux-foundation.org>
In-Reply-To: <1338934303.5780.8.camel@joe2Laptop>
References: <cover.1338889066.git.joe@perches.com>
	<20120605142826.d92316a0.akpm@linux-foundation.org>
	<1338934303.5780.8.camel@joe2Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2012 15:11:43 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2012-06-05 at 14:28 -0700, Andrew Morton wrote:
> > Unfortunately the <n> thing is part of the kernel ABI:
> > 
> > 	echo "<4>foo" > /dev/kmsg
> 
> Which works the same way it did before.

I didn't say it didn't.

What I did say is that echo "\0014">/dev/kmsg will subvert the intent
of the new logging code.  Or might.  But you just ignored all that,
forcing me to repeat myself, irritatedly.


