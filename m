Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2EEUdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 16:33:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:42600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2EEUdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 16:33:41 -0400
Subject: Re: 5fbd036b552f633abb394a319f7c62a5c86a9cd7 breaks PA-RISC boot
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1205042305250.18896@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042305250.18896@file.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 May 2012 22:33:26 +0200
Message-ID: <1336250006.2463.139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 23:26 -0400, Mikulas Patocka wrote:
> Your patch 5fbd036b552f633abb394a319f7c62a5c86a9cd7 breaks PA-RISC boot. I 
> have a dual-core PA-8800. With the patch applied, the kernel crashes with 
> these messages. The timer structures are apparently corrupted, as the 
> timer sees a negative amount of delayed cycles: 

You'll find:

  http://marc.info/?l=linux-parisc&m=133241790810604&w=2

will probably fix the issue.

