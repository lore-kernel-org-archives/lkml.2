Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2FDVJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:09:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2FDVJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:09:46 -0400
Date: Mon, 4 Jun 2012 17:09:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Kevin Hilman <khilman@ti.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/4 V2] introduce: livedump
Message-ID: <20120604210912.GA18354@redhat.com>
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 06:12:07PM +0900, YOSHIDA Masanori wrote:

[..]
> (4) It allocates about 50% of physical RAM to store dumped pages. Currently
>     Live Dump saves all dumped data on memory once, and after that a user
>     becomes able to use the dumped data. Live Dump itself has no feature to
>     save dumped data onto a disk or any other storage device.

People complain when kdump reserves 128M of memory when system crashes.
I am skeptical that reserving 50% of memory for livedumps is going to fly.

Thanks
Vivek
