Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2HaPrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:47:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab2HaPrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:47:47 -0400
Date: Fri, 31 Aug 2012 17:47:45 +0200
From: Michal Marek <mmarek@suse.cz>
To: =?utf-8?B?7J206rG07Zi4?= <urpapa@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/Makefile.modpost: error in finding modules from
 .mod files.
Message-ID: <20120831154745.GG11531@sepie.suse.cz>
References: <CAA5UCLK9Zssct_f_8sSm8bDGeMFaAv_kr2GTFFWSCcP=Xz9ikw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA5UCLK9Zssct_f_8sSm8bDGeMFaAv_kr2GTFFWSCcP=Xz9ikw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:58:12PM +0900, 이건호 wrote:
> This error may happen when the user's id or path includes .ko string.
> For example, user's id is xxx.ko and building test.ko module,
> the test.mod file lists ko name and all object files.
>    /home/xxx.ko/kernel_dev/device/drivers/test.ko
>    /home/xxx.ko/kernel_dev/device/drivers/test_main.o
> /home/xxx.ko/kernel_dev/device/drivers/test_io.o ...
> Current Makefile.modpost and Makefile.modinst find and list up not
> only test.ko but also other object files.
> because all of object file's path includes .ko string.
> This is a patch to fix it.
> 
> Signed-off-by: Gunho Lee <gunho.lee@lge.com>

Good catch, applied to kbuild.git#kbuild. BTW, your mailer (gmail?)
broke the log lines into two. I fixed it manually, but it makes the
recipient's life easier if you send your patches either using
git-send-email or a mailer that does not mangle the message (see
Documentation/email-clients.txt).

Michal
