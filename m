Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0JYQLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:11:25 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50857 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JYQLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:11:24 -0400
Date: Mon, 25 Oct 2010 18:11:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: namhyung@gmail.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sparc32: fix build failure on CONFIG_SPARC_LEON
Message-ID: <20101025161122.GA25358@merkur.ravnborg.org>
References: <1288021958-3130-1-git-send-email-namhyung@gmail.com> <1288021958-3130-3-git-send-email-namhyung@gmail.com> <20101025.090043.71110898.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025.090043.71110898.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 09:00:43AM -0700, David Miller wrote:
> From: Namhyung Kim <namhyung@gmail.com>
> Date: Tue, 26 Oct 2010 00:52:38 +0900
> 
> >   CC      arch/sparc/kernel/irq_32.o
> > arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
> > arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
> 
> I doubt SMP LEON chips even exist, so better to just anti-dep
> this in arch/sparc/Kconfig

I have a nice eval board at my desk with a dual-core LEON4 processor.
I only lack time to play with it...

	Sam
